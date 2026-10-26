/**
 *  This test case verifies CBRD-27735: partition aggregates (nulls).
 *  Partition scan transitions must preserve all qualifying values and finish
 *  without a query error or abnormal server termination.
 *  Every result has an independently calculated oracle and NO_PARALLEL_SCAN
 *  reference. Separate TRACE probes check partition order and worker tokens.
 *  GROUP_CONCAT uses the same explicit limit and ordering for both queries.
 *  Coverage:
 *    Case 1: Basic aggregates
 *    Case 2: COUNT DISTINCT
 *    Case 3: SUM DISTINCT
 *    Case 4: AVG DISTINCT
 *    Case 5: MEDIAN
 *    Case 6: Ordered GROUP_CONCAT length
 *    Case 7: Empty input
 */

drop table if exists td;
set trace off;

-- Large partition: 2048 rows doubled seven times, with 192-byte hash padding
-- This is well above the test-mode 32-page floor (target at least 96 pages)
-- Small partition: at most 100 rows and short padding, well below the floor
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
update td set v=null where mod(id,10)=0;
update statistics on td with fullscan;
set system parameters 'group_concat_max_len=4194304';


evaluate 'Case 1: Basic aggregates; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(v), sum(cast(v as bigint)), min(v), max(v) from td;
select /*+ recompile no_parallel_scan */ count(*), count(v), sum(cast(v as bigint)), min(v), max(v) from td;


evaluate 'Case 2: COUNT DISTINCT; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(distinct v) from td;
select /*+ recompile no_parallel_scan */ count(distinct v) from td;


evaluate 'Case 3: SUM DISTINCT; result = NO_PARALLEL_SCAN';
select /*+ recompile */ sum(distinct v) from td;
select /*+ recompile no_parallel_scan */ sum(distinct v) from td;


evaluate 'Case 4: AVG DISTINCT; result = NO_PARALLEL_SCAN';
select /*+ recompile */ cast(avg(distinct v) as numeric(20,6)) from td;
select /*+ recompile no_parallel_scan */ cast(avg(distinct v) as numeric(20,6)) from td;


evaluate 'Case 5: MEDIAN; result = NO_PARALLEL_SCAN';
select /*+ recompile */ cast(median(v) as numeric(20,6)) from td;
select /*+ recompile no_parallel_scan */ cast(median(v) as numeric(20,6)) from td;


evaluate 'Case 6: Ordered GROUP_CONCAT length; result = NO_PARALLEL_SCAN';
select /*+ recompile */ length(group_concat(v order by v separator ',')) as concat_length from td;
select /*+ recompile no_parallel_scan */ length(group_concat(v order by v separator ',')) as concat_length from td;


evaluate 'Case 7: Empty input; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(distinct v), sum(distinct v), median(v), length(group_concat(v order by v separator ',')) as concat_length from td where id < 0;
select /*+ recompile no_parallel_scan */ count(*), count(distinct v), sum(distinct v), median(v), length(group_concat(v order by v separator ',')) as concat_length from td where id < 0;
set system parameters 'group_concat_max_len=default';
drop table td;
