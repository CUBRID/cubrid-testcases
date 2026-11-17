/**
 *  This test case verifies CBRD-26572: Support UUID()/SYS_GUID() built-in functions.
 *
 *  NOTE: Generated UUID values differ on every execution, so raw values must
 *  never appear in the answer. All checks are derived and deterministic.
 */

 evaluate '[TEST 1] TRUNCATE TABLE then re-insert with UUID(7) default';
drop table if exists uuid_trunc_t;
create table uuid_trunc_t (k int auto_increment primary key, u bit(128) default uuid(7), v int);
insert into uuid_trunc_t(v) select rownum from db_class limit 10;
select count(*) before_trunc from uuid_trunc_t;
-- record the maximum UUID(7) value before truncation
set @max_u_before = (select max(u) from uuid_trunc_t);
truncate table uuid_trunc_t;
-- wait 1 second to guarantee a later UUID(7) timestamp window
select sleep(1);
select count(*) after_trunc from uuid_trunc_t;
insert into uuid_trunc_t(v) select rownum from db_class limit 10;
select count(*) re_inserted from uuid_trunc_t;
select count(distinct u) uniq,
count(case when substr(uuid_format(u), 15, 1) = '7' then 1 end) v7_cnt
from uuid_trunc_t;
-- UUID(7) monotonicity: all new values must be strictly greater than the old max
select min(u) > @max_u_before new_greater_than_old from uuid_trunc_t;

evaluate '[TEST 1.1] AUTO_INCREMENT resets after TRUNCATE but UUID defaults remain functional';
-- verify that auto_increment was reset (k starts from 1 again)
-- while UUID default still generates valid, unique values
select min(k) min_k, max(k) max_k from uuid_trunc_t;
select count(case when substr(uuid_format(u), 20, 1) in ('8', '9', 'A', 'B') then 1 end) variant_ok
from uuid_trunc_t;
drop table uuid_trunc_t;