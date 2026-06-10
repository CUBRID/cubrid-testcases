/**
 *  This test case verifies CBRD-26486: UUID()/SYS_GUID() as a column DEFAULT.
 *  - CREATE TABLE / ALTER TABLE ADD or MODIFY COLUMN with DEFAULT UUID(), UUID(4), UUID(7), SYS_GUID()
 *  - DEFAULT UUID only supports UUID(), UUID(4), or UUID(7); nested expressions are rejected
 *  - catalog (db_attribute) and SHOW CREATE TABLE expose the default expression
 *
 *  NOTE: Generated UUID values differ on every execution, so raw values must
 *  never appear in the answer. All checks are derived and deterministic.
 */

evaluate '[TEST 1] CREATE TABLE with UUID defaults';
drop table if exists uuid_def_t;
create table uuid_def_t (id4 bit(128) default uuid(4), id7 bit(128) default uuid(7), g char(32) default sys_guid());
show create table uuid_def_t;
select attr_name, data_type, prec, default_value from db_attribute where class_name = 'uuid_def_t' order by def_order;

evaluate '[TEST 2] INSERT DEFAULT variations generate per-row values';
insert into uuid_def_t values default;
insert into uuid_def_t values (default, default, default);
insert into uuid_def_t values default, (default, default, default);
insert into uuid_def_t(id4) values (null);
insert into uuid_def_t(id7) values (null);
insert into uuid_def_t(g) values (null);
select count(*) total,
       count(id4) id4_non_null, count(distinct id4) id4_uniq,
       count(id7) id7_non_null, count(distinct id7) id7_uniq,
       count(g) g_non_null, count(distinct g) g_uniq
from uuid_def_t;
select count(case when substr(uuid_format(id4), 15, 1) = '4' then 1 end) id4_is_v4,
       count(case when substr(uuid_format(id7), 15, 1) = '7' then 1 end) id7_is_v7,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_is_hex
from uuid_def_t;
drop table uuid_def_t;

evaluate '[TEST 2.1] DEFAULT UUID() with no argument behaves as UUID(4)';
drop table if exists uuid_def_noarg;
create table uuid_def_noarg (a bit(128) default uuid(), v int);
show create table uuid_def_noarg;
insert into uuid_def_noarg(v) values (1), (2), (3);
select count(*) total, count(distinct a) uniq,
       count(case when substr(uuid_format(a), 15, 1) = '4' then 1 end) is_v4
from uuid_def_noarg;
drop table uuid_def_noarg;

evaluate '[TEST 3] ALTER TABLE ADD COLUMN with UUID default fills existing rows with distinct values';
create table uuid_def_t (n int);
insert into uuid_def_t select rownum from db_class limit 5;
alter table uuid_def_t add column id4 bit(128) default uuid(4);
alter table uuid_def_t add column id7 bit(128) default uuid(7);
alter table uuid_def_t add column g1 char(32) default sys_guid();
alter table uuid_def_t add column g2 string default sys_guid();
select count(*) total,
       count(distinct id4) id4_uniq, count(distinct id7) id7_uniq,
       count(distinct g1) g1_uniq, count(distinct g2) g2_uniq
from uuid_def_t;
select count(case when substr(uuid_format(id4), 15, 1) = '4' then 1 end) id4_is_v4,
       count(case when substr(uuid_format(id7), 15, 1) = '7' then 1 end) id7_is_v7
from uuid_def_t;
show create table uuid_def_t;
drop table uuid_def_t;

evaluate '[TEST 4] ALTER MODIFY / CHANGE / ALTER SET DEFAULT vary the UUID default; verify each change';
drop table if exists uuid_alt_t;
create table uuid_alt_t (k int auto_increment primary key, b bit(128) default uuid(4), g char(32) default sys_guid());
show create table uuid_alt_t;

evaluate '[TEST 4.1] MODIFY changes default UUID(4) -> UUID(7): existing rows keep old default, new rows use the new one';
insert into uuid_alt_t(k) values (null), (null), (null);
alter table uuid_alt_t modify column b bit(128) default uuid(7);
select default_value from db_attribute where class_name = 'uuid_alt_t' and attr_name = 'b';
insert into uuid_alt_t(k) values (null);
select count(case when substr(uuid_format(b), 15, 1) = '4' then 1 end) old_v4_preserved,
       count(case when substr(uuid_format(b), 15, 1) = '7' then 1 end) new_v7
from uuid_alt_t;
delete from uuid_alt_t;

evaluate '[TEST 4.2] MODIFY changes the default to UUID() (version 4)';
alter table uuid_alt_t modify column b bit(128) default uuid();
select default_value from db_attribute where class_name = 'uuid_alt_t' and attr_name = 'b';
insert into uuid_alt_t(k) values (null);
select substr(uuid_format(b), 15, 1) b_ver from uuid_alt_t order by k desc limit 1;
delete from uuid_alt_t;

evaluate '[TEST 4.3] CHANGE renames the column b -> bid and sets a UUID(7) default';
alter table uuid_alt_t change column b bid bit(128) default uuid(7);
show create table uuid_alt_t;
insert into uuid_alt_t(k) values (null);
select substr(uuid_format(bid), 15, 1) bid_ver from uuid_alt_t order by k desc limit 1;
delete from uuid_alt_t;

evaluate '[TEST 4.4] CHANGE keeps the name and switches the default back to UUID(4)';
alter table uuid_alt_t change column bid bid bit(128) default uuid(4);
select default_value from db_attribute where class_name = 'uuid_alt_t' and attr_name = 'bid';
insert into uuid_alt_t(k) values (null);
select substr(uuid_format(bid), 15, 1) bid_ver from uuid_alt_t order by k desc limit 1;
delete from uuid_alt_t;

evaluate '[TEST 4.5] ALTER SET DEFAULT NULL drops the SYS_GUID default on column g';
alter table uuid_alt_t alter column g set default null;
select default_value from db_attribute where class_name = 'uuid_alt_t' and attr_name = 'g';
insert into uuid_alt_t(k) values (null);
select count(*) total, count(g) g_non_null from uuid_alt_t;
delete from uuid_alt_t;

evaluate '[TEST 4.6] ALTER SET DEFAULT restores the SYS_GUID() default on column g';
alter table uuid_alt_t alter column g set default sys_guid();
select default_value from db_attribute where class_name = 'uuid_alt_t' and attr_name = 'g';
insert into uuid_alt_t(k) values (null);
select count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_hex from uuid_alt_t;
delete from uuid_alt_t;

evaluate '[TEST 4.7] ALTER SET DEFAULT also sets a UUID default on the bit column (UUID(4) -> UUID(7))';
alter table uuid_alt_t alter column bid set default uuid(7);
select default_value from db_attribute where class_name = 'uuid_alt_t' and attr_name = 'bid';
insert into uuid_alt_t(k) values (null);
select substr(uuid_format(bid), 15, 1) bid_ver from uuid_alt_t order by k desc limit 1;

show create table uuid_alt_t;
drop table uuid_alt_t;


evaluate '[TEST 5] UUID default on PRIMARY KEY column';
create table uuid_def_t (id bit(128) default uuid(7) primary key, v int);
insert into uuid_def_t(v) values (1), (2), (3);
insert into uuid_def_t values (default, 4);
select count(*) total, count(distinct id) uniq from uuid_def_t;
drop table uuid_def_t;

evaluate '[TEST 6] nested UUID expression in DEFAULT -> error (UUID cannot be nested, SYS_GUID can)';
-- Each negative case uses a distinct table name so a case that wrongly succeeds
-- cannot leave a table that makes a later case fail for the wrong reason; the final
-- count must be 0, and would expose any case that created its table.
drop table if exists uuid_def_e1, uuid_def_e2;
create table uuid_def_e1 (a bit(128) default to_char(uuid()));
create table uuid_def_e2 (a bit(128) default uuid(1+3));
select count(*) wrongly_created from db_class where class_name in ('uuid_def_e1', 'uuid_def_e2');
drop table if exists uuid_def_nest;
create table uuid_def_nest (a string default to_char(sys_guid()));
show create table uuid_def_nest;
insert into uuid_def_nest values (default);
select count(*) total, count(case when regexp_like(a, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) a_is_hex from uuid_def_nest;
drop table uuid_def_nest;

evaluate '[TEST 7] unsupported or NULL UUID version in DEFAULT -> error';
drop table if exists uuid_def_e3, uuid_def_e4, uuid_def_e5, uuid_def_e5b;
create table uuid_def_e3 (a bit(128) default uuid(1));
create table uuid_def_e4 (a bit(128) default uuid(5));
create table uuid_def_e5 (a bit(128) default uuid(8));
create table uuid_def_e5b (a bit(128) default uuid(null));
select count(*) wrongly_created from db_class where class_name in ('uuid_def_e3', 'uuid_def_e4', 'uuid_def_e5', 'uuid_def_e5b');

evaluate '[TEST 8] DEFAULT type coercion failures -> error';
drop table if exists uuid_def_e6, uuid_def_e7, uuid_def_e8, uuid_def_e9;
create table uuid_def_e6 (a string default uuid(7));
create table uuid_def_e7 (a varchar(40) default uuid(4));
create table uuid_def_e8 (a bit(128) default sys_guid());
create table uuid_def_e9 (a char(31) default sys_guid());
select count(*) wrongly_created from db_class where class_name in ('uuid_def_e6', 'uuid_def_e7', 'uuid_def_e8', 'uuid_def_e9');

evaluate '[TEST 9] ALTER TABLE ADD COLUMN error cases';
-- Distinct column names so a case that wrongly succeeds does not turn a later case
-- into an already-exists failure; the final count of added columns must be 0.
drop table if exists uuid_def_t;
create table uuid_def_t (n int);
alter table uuid_def_t add column c1 bit(128) default to_char(uuid());
alter table uuid_def_t add column c2 bit(128) default uuid(3+4);
alter table uuid_def_t add column c3 bit(128) default uuid(5);
alter table uuid_def_t add column c4 string default uuid(7);
alter table uuid_def_t add column c5 bit(128) default uuid(null);
select count(*) wrongly_added from db_attribute where class_name = 'uuid_def_t' and attr_name in ('c1', 'c2', 'c3', 'c4', 'c5');
drop table uuid_def_t;
