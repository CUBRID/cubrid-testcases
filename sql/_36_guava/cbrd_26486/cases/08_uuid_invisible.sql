/**
 *  This test case verifies CBRD-26486: UUID defaults combined with PRIMARY KEY
 *  and INVISIBLE/VISIBLE columns.
 *  - CREATE TABLE with an INVISIBLE PRIMARY KEY column defaulting to UUID(7)
 *  - INSERT without a column list skips invisible columns, so the UUID default
 *    is applied per row while explicit column lists can still set the value
 *  - SELECT * excludes the invisible UUID column
 *  - ALTER TABLE MODIFY toggles VISIBLE/INVISIBLE while keeping the UUID default
 *  - ALTER TABLE ADD COLUMN ... INVISIBLE with UUID default fills existing rows
 *
 *  NOTE: raw UUID values never appear in the answer. While the UUID column is
 *  visible, SELECT * is avoided. Only derived counts are checked.
 */

evaluate '[TEST 1] INVISIBLE PRIMARY KEY with DEFAULT UUID(7)';
drop table if exists uuid_inv_t;
create table uuid_inv_t (id bit(128) default uuid(7) invisible primary key, v int);
show create table uuid_inv_t;
desc uuid_inv_t;

evaluate '[TEST 2] INSERT without column list applies the UUID default to the invisible PK';
insert into uuid_inv_t values (1), (2), (3);
insert into uuid_inv_t(v) values (4);
insert into uuid_inv_t values default;
insert into uuid_inv_t(id, v) values (uuid(7), 6);
select * from uuid_inv_t order by 1;
select count(*) total, count(id) non_null, count(distinct id) uniq,
       count(case when substr(uuid_format(id), 15, 1) = '7' then 1 end) v7_cnt,
       count(case when substr(uuid_format(id), 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from uuid_inv_t;

evaluate '[TEST 3] explicit NULL into the invisible PK -> NOT NULL constraint error';
insert into uuid_inv_t(id, v) values (null, 7);
select count(*) total from uuid_inv_t;

evaluate '[TEST 4] UPDATE regenerates the invisible UUID PK per row';
drop table if exists uuid_inv_before;
create table uuid_inv_before (v int primary key, id bit(128));
insert into uuid_inv_before
select v, id from uuid_inv_t where v <= 3;
update uuid_inv_t set id = uuid(7) where v <= 3;
select count(case when t.id <> b.id then 1 end) changed
from uuid_inv_t t, uuid_inv_before b
where t.v = b.v;
select count(*) total, count(distinct id) uniq,
       count(case when substr(uuid_format(id), 15, 1) = '7' then 1 end) v7_cnt
from uuid_inv_t;
drop table uuid_inv_before;

evaluate '[TEST 5] toggle INVISIBLE -> VISIBLE -> INVISIBLE keeps the UUID default';
alter table uuid_inv_t modify column id bit(128) default uuid(7) visible;
show create table uuid_inv_t;
desc uuid_inv_t;
insert into uuid_inv_t(v) values (10);
select count(*) total, count(distinct id) uniq from uuid_inv_t;
alter table uuid_inv_t modify column id bit(128) default uuid(7) invisible;
show create table uuid_inv_t;
select * from uuid_inv_t where v = 10;
drop table uuid_inv_t;

evaluate '[TEST 6] ALTER TABLE ADD COLUMN ... INVISIBLE with UUID defaults fills existing rows';
create table uuid_inv_t (n int primary key);
insert into uuid_inv_t select rownum from db_attribute limit 100;
alter table uuid_inv_t add column u7 bit(128) default uuid(7) invisible;
alter table uuid_inv_t add column g char(32) default sys_guid() invisible first;
show create table uuid_inv_t;
select * from uuid_inv_t order by n limit 3;
select count(*) total,
       count(u7) u7_non_null, count(distinct u7) u7_uniq,
       count(case when substr(uuid_format(u7), 15, 1) = '7' then 1 end) v7_cnt,
       count(g) g_non_null, count(distinct g) g_uniq,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_hex_cnt
from uuid_inv_t;
drop table uuid_inv_t;

evaluate '[TEST 7] invisible SYS_GUID primary key: catalog view';
create table uuid_inv_t (id char(32) default sys_guid() invisible primary key, v int);
select attr_name, data_type, prec, default_value, is_invisible from db_attribute where class_name = 'uuid_inv_t' order by def_order;
insert into uuid_inv_t values (1), (2);
select count(*) total, count(distinct id) uniq,
       count(case when regexp_like(id, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) hex_cnt
from uuid_inv_t;
drop table uuid_inv_t;

evaluate '[TEST 8] error cases: invisible UUID column rules follow the generic invisible rules';
drop table if exists uuid_inv_err;
create table uuid_inv_err (a bit(128) default uuid(7) invisible);
create table uuid_inv_err (a bit(128) default uuid(7) invisible, b char(32) default sys_guid() invisible);
select count(*) not_created from db_class where class_name = 'uuid_inv_err';
drop table if exists uuid_inv_err;
