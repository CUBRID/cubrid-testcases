/**
 *  This test case verifies CBRD-26572: Support UUID()/SYS_GUID() built-in functions.
 *
 *  NOTE: Generated UUID values differ on every execution, so raw values must
 *  never appear in the answer. All checks are derived and deterministic.
 */

evaluate '[TEST 1] REPLACE generates new UUID default for the replacement row';
drop table if exists uuid_replace_t;
create table uuid_replace_t (k int primary key, u bit(128) default uuid(7), v int);
insert into uuid_replace_t(k, v) values (1, 10), (2, 20), (3, 30);
select count(distinct u) orig_uniq from uuid_replace_t;
-- record the original UUID for k=2 before REPLACE
set @u2_before = (select u from uuid_replace_t where k = 2);
replace into uuid_replace_t(k, v) values (2, 200);
-- the replacement row must have a new UUID (different from the original)
select (u <> @u2_before) uuid_changed from uuid_replace_t where k = 2;
select count(*) total, count(distinct u) uniq,
count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt
from uuid_replace_t;
select v from uuid_replace_t where k = 2;

evaluate '[TEST 1.1] INSERT ON DUPLICATE KEY UPDATE preserves UUID on unmentioned columns';
-- ODKU updates only v; column u has DEFAULT UUID(7) but must NOT be regenerated
set @u3_before = (select u from uuid_replace_t where k = 3);
insert into uuid_replace_t(k, v) values (3, 300) on duplicate key update v = 300;
-- the UUID must be exactly the same as before the ODKU
select (u = @u3_before) uuid_preserved from uuid_replace_t where k = 3;
select count(*) total, count(distinct u) uniq from uuid_replace_t;
select v from uuid_replace_t where k = 3;

evaluate '[TEST 1.2] INSERT ON DUPLICATE KEY UPDATE with explicit UUID regeneration';
-- ODKU that explicitly sets u = uuid(7) must produce a new value
set @u1_before = (select u from uuid_replace_t where k = 1);
insert into uuid_replace_t(k, v) values (1, 100) on duplicate key update v = 100, u = uuid(7);
select (u <> @u1_before) uuid_changed from uuid_replace_t where k = 1;
select count(*) total, count(distinct u) uniq from uuid_replace_t;
drop table uuid_replace_t;