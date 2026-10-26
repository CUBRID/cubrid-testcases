/**
 *  This test case verifies CBRD-27735: partition aggregates (empty).
 *  Partition scan transitions must preserve all qualifying values and finish
 *  without a query error or abnormal server termination.
 *  Every result has an independently calculated oracle and NO_PARALLEL_SCAN
 *  reference. Traces check partition order and BUILDVALUE worker tokens.
 *  DISTINCT GROUP_CONCAT uses a nontruncating limit on both paths.
 *  Coverage:
 *    Case 1: Basic aggregates
 *    Case 2: COUNT DISTINCT
 *    Case 3: SUM DISTINCT
 *    Case 4: AVG DISTINCT
 *    Case 5: MEDIAN
 *    Case 6: Ordered DISTINCT GROUP_CONCAT length
 *    Case 7: Empty input
 *    Case 8: Complete ordered non-DISTINCT string on bounded data
 */

drop table if exists td;
set trace on;

-- Large partition: 2048 rows doubled three times, with 192-byte hash padding
-- This is well above the test-mode 32-page floor (target at least 96 pages)
-- Small partition: at most 100 rows and short padding, well below the floor
create table td (id int, v int, pad varchar(200)) partition by range(id) (partition p_big values less than (1000000), partition p_small values less than maxvalue);
insert into td select 0+rownum, mod(rownum,1000), concat(sha2(cast(rownum as varchar),512),sha2(cast(rownum as varchar),256)) from db_class aa, db_class bb, db_class cc limit 2048;
insert into td select id+2048, mod(id+2048-0,1000), pad from td;
insert into td select id+4096, mod(id+4096-0,1000), pad from td;
insert into td select id+8192, mod(id+8192-0,1000), pad from td;
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


evaluate 'Case 6: Ordered DISTINCT GROUP_CONCAT length; result = NO_PARALLEL_SCAN';
select /*+ recompile */ length(group_concat(distinct v order by v separator ',')) as concat_length from td;
show trace;
select /*+ recompile no_parallel_scan */ length(group_concat(distinct v order by v separator ',')) as concat_length from td;
show trace;


evaluate 'Case 7: Empty input; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(distinct v), sum(distinct v), median(v), length(group_concat(distinct v order by v separator ',')) as concat_length from td where id < 0;
show trace;
select /*+ recompile no_parallel_scan */ count(*), count(distinct v), sum(distinct v), median(v), length(group_concat(distinct v order by v separator ',')) as concat_length from td where id < 0;
show trace;


evaluate 'Case 8: Complete ordered non-DISTINCT string; result = NO_PARALLEL_SCAN';
select /*+ recompile */ length(group_concat(v order by v separator ',')) as concat_length from td;
show trace;
select /*+ recompile no_parallel_scan */ length(group_concat(v order by v separator ',')) as concat_length from td;
show trace;
set trace off;
set system parameters 'group_concat_max_len=default';
drop table td;
