/**
 *  This test case verifies CBRD-27735: partition aggregates (base: default
 *  partition order, large partition first, full-size data).
 *  Partition scan transitions must preserve all qualifying values and finish
 *  without a query error or abnormal server termination.
 *  Each result is checked against its NO_PARALLEL_SCAN twin; Case 8 is also
 *  checked against an independently calculated length and MD5.
 *  Traces check partition order and BUILDVALUE worker tokens.
 *  DISTINCT GROUP_CONCAT uses a nontruncating limit on both paths.
 *  Coverage:
 *    Case 1: Basic aggregates
 *    Case 2: COUNT DISTINCT
 *    Case 3: SUM DISTINCT
 *    Case 4: AVG DISTINCT
 *    Case 5: MEDIAN
 *    Case 6: Ordered DISTINCT GROUP_CONCAT MD5
 *    Case 7: Empty input
 *    Case 8: Complete ordered non-DISTINCT string on the full data
 */

drop table if exists td;
set trace on;

-- Large partition: 2048 rows doubled seven times (262,144 rows), with
-- 192-byte hash padding, about 4165 heap pages - well above the test-mode
-- 32-page parallel-scan floor; also what Case 8's timing below needs.
-- Small partition: at most 100 rows and short padding, 1 heap page -
-- well below the floor
create table td (id int, v int, pad varchar(200)) partition by range(id) (partition p_big values less than (1000000), partition p_small values less than maxvalue);
insert into td select 0+rownum, mod(rownum,1000), concat(sha2(cast(rownum as varchar),512),sha2(cast(rownum as varchar),256)) from db_class aa, db_class bb, db_class cc limit 2048;
insert into td select id+2048, mod(id+2048-0,1000), pad from td;
insert into td select id+4096, mod(id+4096-0,1000), pad from td;
insert into td select id+8192, mod(id+8192-0,1000), pad from td;
insert into td select id+16384, mod(id+16384-0,1000), pad from td;
insert into td select id+32768, mod(id+32768-0,1000), pad from td;
insert into td select id+65536, mod(id+65536-0,1000), pad from td;
insert into td select id+131072, mod(id+131072-0,1000), pad from td;
insert into td select 1000000+rownum, 5000+rownum, 's' from db_class aa, db_class bb limit 100;
update statistics on td with fullscan;
set system parameters 'group_concat_max_len=4194304';


evaluate 'Case 1: Basic aggregates; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(v), sum(cast(v as bigint)), min(v), max(v) from td;
show trace;
select /*+ recompile no_parallel_scan */ count(*), count(v), sum(cast(v as bigint)), min(v), max(v) from td;
show trace;


evaluate 'Case 2: COUNT DISTINCT; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(distinct v) from td;
show trace;
select /*+ recompile no_parallel_scan */ count(distinct v) from td;
show trace;


evaluate 'Case 3: SUM DISTINCT; result = NO_PARALLEL_SCAN';
select /*+ recompile */ sum(distinct v) from td;
show trace;
select /*+ recompile no_parallel_scan */ sum(distinct v) from td;
show trace;


evaluate 'Case 4: AVG DISTINCT; result = NO_PARALLEL_SCAN';
select /*+ recompile */ cast(avg(distinct v) as numeric(20,6)) from td;
show trace;
select /*+ recompile no_parallel_scan */ cast(avg(distinct v) as numeric(20,6)) from td;
show trace;


evaluate 'Case 5: MEDIAN; result = NO_PARALLEL_SCAN';
select /*+ recompile */ cast(median(v) as numeric(20,6)) from td;
show trace;
select /*+ recompile no_parallel_scan */ cast(median(v) as numeric(20,6)) from td;
show trace;


evaluate 'Case 6: Ordered DISTINCT GROUP_CONCAT MD5; result = NO_PARALLEL_SCAN';
select /*+ recompile */ md5(group_concat(distinct v order by v separator ',')) as concat_md5 from td;
show trace;
select /*+ recompile no_parallel_scan */ md5(group_concat(distinct v order by v separator ',')) as concat_md5 from td;
show trace;


evaluate 'Case 7: Empty input; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(distinct v), sum(distinct v), median(v), length(group_concat(distinct v order by v separator ',')) as concat_length from td where v < 0;
show trace;
select /*+ recompile no_parallel_scan */ count(*), count(distinct v), sum(distinct v), median(v), length(group_concat(distinct v order by v separator ',')) as concat_length from td where v < 0;
show trace;


-- The original PR left this case out: CBRD-27926 made GROUP_CONCAT rebuild
-- its whole accumulated string on every value appended, so a non-DISTINCT
-- concatenation of all 262,244 rows (about 1 MB of output) ran long enough
-- to miss the CTP timeout. CBRD-27926 is fixed (develop, 2026-11-09), so
-- this case is added back. Independently computed from the same values
-- (not from this engine): sorting all 262,244 v values and joining them
-- with ',' gives a string of length 1020147, MD5 38afba4a93908d30538aa9baf29839ea.
evaluate 'Case 8: Complete ordered non-DISTINCT string on the full data; result = 1020147, 38afba4a93908d30538aa9baf29839ea';
select /*+ recompile */ length(group_concat(v order by v separator ',')) as concat_length, md5(group_concat(v order by v separator ',')) as concat_md5 from td;
show trace;
select /*+ recompile no_parallel_scan */ length(group_concat(v order by v separator ',')) as concat_length, md5(group_concat(v order by v separator ',')) as concat_md5 from td;
show trace;
set trace off;
set system parameters 'group_concat_max_len=default';
drop table td;
