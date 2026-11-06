/**
 *  This test case verifies CBRD-26572: UUID()/SYS_GUID() values in DML.
 *  - INSERT into BIT / BIT VARYING / CHAR / VARCHAR columns with type coercion
 *  - INSERT ... SELECT, UPDATE SET, WHERE clause usage
 *  - storage overflow errors for columns narrower than 128 bits / 32 chars
 *
 *  NOTE: Generated UUID values differ on every execution, so raw values must
 *  never appear in the answer. All checks are derived and deterministic.
 *  BIT(127) is intentionally NOT tested: a 128-bit UUID fits only when its
 *  last bit happens to be 0, which would make the result non-deterministic.
 */

evaluate '[TEST 1] INSERT generated UUIDs into various column types';
drop table if exists uuid_dml_t;
create table uuid_dml_t (a bit(128), b bit varying, c string, d char(32), e varchar(40));
insert into uuid_dml_t values (uuid(), uuid(), uuid(), uuid(), uuid());
insert into uuid_dml_t values (uuid(0), uuid(0), uuid(0), uuid(0), uuid(0));
insert into uuid_dml_t values (uuid(4), uuid(4), uuid(4), uuid(4), uuid(4));
insert into uuid_dml_t values (uuid('4'), uuid('4'), uuid('4'), uuid('4'), uuid('4'));
insert into uuid_dml_t values (uuid(7), uuid(7), uuid(7), uuid(7), uuid(7));
insert into uuid_dml_t values (uuid('7'), uuid('7'), uuid('7'), uuid('7'), uuid('7'));
insert into uuid_dml_t values (sys_guid(), sys_guid(), sys_guid(), sys_guid(), sys_guid());
-- NOTE: UUID(NULL) raises an error in every context (see TEST 8), so it is not mixed
-- into the valid rows here.
select bit_length(a) len_a, bit_length(b) len_b, char_length(c) len_c, char_length(d) len_d, char_length(e) len_e
from uuid_dml_t
order by 1, 2, 3, 4, 5;
select count(*) total, count(a) a_non_null, count(distinct a) a_uniq from uuid_dml_t;
select substr(uuid_format(a), 15, 1) version, count(*) cnt
from uuid_dml_t
where a is not null
group by substr(uuid_format(a), 15, 1)
order by version;
-- NOTE: a BIT(128) UUID coerced into a character column is stored as lowercase hex,
-- while SYS_GUID() returns uppercase hex: 6 coerced rows + 1 SYS_GUID row below.
select count(case when bit_length(b) = 128 then 1 end) b_len_ok,
       count(case when regexp_like(c, '^[0-9a-fA-F]{32}$', 'c') = 1 then 1 end) c_hex,
       count(case when regexp_like(c, '^[0-9a-f]{32}$', 'c') = 1 then 1 end) c_lower_hex,
       count(case when regexp_like(c, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) c_upper_hex,
       count(case when regexp_like(d, '^[0-9a-fA-F]{32}$', 'c') = 1 then 1 end) d_hex,
       count(case when regexp_like(e, '^[0-9a-fA-F]{32}$', 'c') = 1 then 1 end) e_hex
from uuid_dml_t;
drop table uuid_dml_t;

evaluate '[TEST 2] storage of wider columns: CHAR(33) is padded, BIT(129) is padded';
create table uuid_dml_t (a char(33), b bit(129));
insert into uuid_dml_t values (sys_guid(), uuid());
insert into uuid_dml_t values (sys_guid(), uuid(7));
select char_length(a) len_a, bit_length(b) len_b, substr(uuid_format(rtrim(a)), 15, 1) version_a from uuid_dml_t order by 3;
drop table uuid_dml_t;

evaluate '[TEST 3] storage overflow on narrower columns -> error';
create table uuid_dml_t (a char(31), b varchar(31));
insert into uuid_dml_t(a) values (sys_guid());
insert into uuid_dml_t(a) values (uuid());
insert into uuid_dml_t(a) values (uuid(7));
insert into uuid_dml_t(b) values (sys_guid());
select count(*) from uuid_dml_t;
drop table uuid_dml_t;

evaluate '[TEST 4] INSERT ... SELECT generates a distinct value per row';
create table uuid_dml_t (n int, u bit(128));
insert into uuid_dml_t select rownum, uuid(4) from db_class a, db_class b limit 500;
select count(*) total, count(distinct u) uniq,
       count(case when substr(uuid_format(u), 15, 1) = '4' then 1 end) v4_cnt
from uuid_dml_t;

evaluate '[TEST 5] UPDATE SET evaluates UUID per row';
update uuid_dml_t set u = uuid(7);
select count(*) total, count(distinct u) uniq,
       count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt
from uuid_dml_t;
update uuid_dml_t set u = sys_guid() where n <= 100;
select count(*) total, count(distinct u) uniq,
       count(case when substr(uuid_format(u), 15, 1) = '4' then 1 end) v4_cnt,
       count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt
from uuid_dml_t;

evaluate '[TEST 6] UUID in WHERE / expressions';
select count(*) from uuid_dml_t where uuid() is not null;
select count(*) from uuid_dml_t where substr(uuid_format(uuid(7)), 15, 1) = '7';
select count(*) from uuid_dml_t where uuid_format(u) = uuid_format(u);
delete from uuid_dml_t where uuid_format(uuid(4)) is null;
select count(*) total from uuid_dml_t;
drop table uuid_dml_t;

evaluate '[TEST 7] SYS_GUID string value coerced into BIT(128) on INSERT';
create table uuid_dml_t (a bit(128));
insert into uuid_dml_t values (sys_guid());
insert into uuid_dml_t values (cast(sys_guid() as bit(128)));
select bit_length(a) len_a, substr(uuid_format(a), 15, 1) version_a from uuid_dml_t;
drop table uuid_dml_t;

evaluate '[TEST 8] UUID(NULL) is rejected in every DML context (no row is inserted)';
create table uuid_dml_t (a bit(128));
insert into uuid_dml_t values (uuid(null));
insert into uuid_dml_t select uuid(null) from db_root;
insert into uuid_dml_t(a) values (uuid(cast(null as int)));
select count(*) stays_empty from uuid_dml_t;
drop table uuid_dml_t;

evaluate '[TEST 9] column-sourced numeric version arguments follow the same coercion rules as literals';
drop table if exists uuid_arg_col_t;
create table uuid_arg_col_t (id int, ver numeric(10, 3));
insert into uuid_arg_col_t values (1, 0), (2, 3.9), (3, 4.111), (4, 6.5), (5, 7.321);
select id, substr(uuid_format(uuid(ver)), 15, 1) version_nibble
from uuid_arg_col_t
order by id;
 
evaluate '[TEST 10] column-sourced value that rounds to an unsupported version errors the same as a literal';
insert into uuid_arg_col_t values (6, 4.9);
select uuid(ver) from uuid_arg_col_t where id = 6;
drop table uuid_arg_col_t;
