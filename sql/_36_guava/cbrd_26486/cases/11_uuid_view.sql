/**
 *  This test case verifies CBRD-26572: Support UUID()/SYS_GUID() built-in functions.
 *
 *  NOTE: Generated UUID values differ on every execution, so raw values must
 *  never appear in the answer. All checks are derived and deterministic.
 */

evaluate '[TEST 1] VIEW with UUID functions generates distinct values per query';
drop view if exists uuid_view;
drop table if exists uuid_view_t;
create table uuid_view_t (n int);
insert into uuid_view_t select rownum from db_class limit 5;
create view uuid_view as
select n, uuid(4) u4, uuid(7) u7, sys_guid() g from uuid_view_t;

select count(*) total,
count(distinct u4) u4_uniq,
count(distinct u7) u7_uniq,
count(distinct g) g_uniq,
count(case when substr(uuid_format(u4), 15, 1) = '4' then 1 end) v4_cnt,
count(case when substr(uuid_format(u7), 15, 1) = '7' then 1 end) v7_cnt,
count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_hex_cnt
from uuid_view;

evaluate '[TEST 1.1] consecutive VIEW reads produce entirely different UUID sets';
-- Two independent reads of the same VIEW must generate separate UUID values.
-- A cross join with equality finds no matches because UUID(4) is random and
-- each subquery evaluates the VIEW independently.
select count(*) overlap
from (select u4 from uuid_view) a,
(select u4 from uuid_view) b
where a.u4 = b.u4;

drop view uuid_view;
drop table uuid_view_t;