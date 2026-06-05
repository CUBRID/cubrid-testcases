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

evaluate '[TEST 4] ALTER TABLE MODIFY changes the UUID default, SET DEFAULT NULL drops it';
alter table uuid_def_t modify column id4 bit(128) default uuid(7);
alter table uuid_def_t alter column id7 set default null;
show create table uuid_def_t;
drop table uuid_def_t;

evaluate '[TEST 5] UUID default on PRIMARY KEY column';
create table uuid_def_t (id bit(128) default uuid(7) primary key, v int);
insert into uuid_def_t(v) values (1), (2), (3);
insert into uuid_def_t values (default, 4);
select count(*) total, count(distinct id) uniq from uuid_def_t;
drop table uuid_def_t;

evaluate '[TEST 6] nested UUID expression in DEFAULT -> error (UUID cannot be nested, SYS_GUID can)';
drop table if exists uuid_def_err;
create table uuid_def_err (a bit(128) default to_char(uuid()));
create table uuid_def_err (a bit(128) default uuid(1+3));
select count(*) not_created from db_class where class_name = 'uuid_def_err';
drop table if exists uuid_def_nest;
create table uuid_def_nest (a string default to_char(sys_guid()));
show create table uuid_def_nest;
insert into uuid_def_nest values (default);
select count(*) total, count(case when regexp_like(a, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) a_is_hex from uuid_def_nest;
drop table uuid_def_nest;

evaluate '[TEST 7] unsupported UUID version in DEFAULT -> error';
create table uuid_def_err (a bit(128) default uuid(1));
create table uuid_def_err (a bit(128) default uuid(5));
create table uuid_def_err (a bit(128) default uuid(8));
select count(*) not_created from db_class where class_name = 'uuid_def_err';

evaluate '[TEST 8] DEFAULT type coercion failures -> error';
create table uuid_def_err (a string default uuid(7));
create table uuid_def_err (a varchar(40) default uuid(4));
create table uuid_def_err (a bit(128) default sys_guid());
create table uuid_def_err (a char(31) default sys_guid());
select count(*) not_created from db_class where class_name = 'uuid_def_err';

evaluate '[TEST 9] ALTER TABLE ADD COLUMN error cases';
create table uuid_def_t (n int);
alter table uuid_def_t add column a bit(128) default to_char(uuid());
alter table uuid_def_t add column a bit(128) default uuid(3+4);
alter table uuid_def_t add column a bit(128) default uuid(5);
alter table uuid_def_t add column a string default uuid(7);
drop table uuid_def_t;
