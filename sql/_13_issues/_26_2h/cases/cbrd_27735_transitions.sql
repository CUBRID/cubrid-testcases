/**
 *  This test case verifies CBRD-27735: aggregate-list partition boundaries.
 *  Large, small and large partitions test repeated BUILDVALUE passes.
 *  Result twins use NO_PARALLEL_SCAN, and traces identify the scan paths.
 *  Empty and all-NULL lists must not lose later serial-partition values.
 *  Coverage:
 *    Case 1: Parallel serial parallel mixed lists
 *    Case 2: No qualifying rows after full scan
 *    Case 3: All NULL aggregate arguments
 *    Case 4: Only serial partition contributes
 *    Case 5: Final parallel partition only
 *    Case 6: Exactly one non-NULL value after an empty parallel pass
 */

drop table if exists td;
set trace on;

-- Large partition: 2048 rows doubled three times, with 192-byte hash padding
-- This is well above the test-mode 32-page floor (target at least 96 pages)
-- Small partition: at most 100 rows and short padding, well below the floor
create table td (id int, v int, pad varchar(200)) partition by range(id) (partition p_big values less than (1000000), partition p_small values less than (2000000), partition p_last values less than maxvalue);
insert into td select 0+rownum, mod(rownum,1000), concat(sha2(cast(rownum as varchar),512),sha2(cast(rownum as varchar),256)) from db_class aa, db_class bb, db_class cc limit 2048;
insert into td select id+2048, mod(id+2048-0,1000), pad from td;
insert into td select id+4096, mod(id+4096-0,1000), pad from td;
insert into td select id+8192, mod(id+8192-0,1000), pad from td;
insert into td select 1000000+rownum, 5000+rownum, 's' from db_class aa, db_class bb limit 100;
insert into td select id+2000000, v+10000, pad from td where id < 1000000;
update statistics on td with fullscan;
set system parameters 'group_concat_max_len=4194304';


evaluate 'Case 1: Parallel serial parallel mixed lists; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(distinct v), sum(distinct v), cast(median(v) as numeric(20,6)), md5(group_concat(distinct v order by v separator ',')) as concat_md5 from td;
show trace;
select /*+ recompile no_parallel_scan */ count(*), count(distinct v), sum(distinct v), cast(median(v) as numeric(20,6)), md5(group_concat(distinct v order by v separator ',')) as concat_md5 from td;
show trace;


evaluate 'Case 2: No qualifying rows after full scan; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(distinct v), sum(distinct v), median(v) from td where v < 0;
show trace;
select /*+ recompile no_parallel_scan */ count(*), count(distinct v), sum(distinct v), median(v) from td where v < 0;
show trace;


evaluate 'Case 3: All NULL aggregate arguments; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(distinct case when v < 0 then v end), sum(distinct case when v < 0 then v end), median(case when v < 0 then v end), length(group_concat(case when v < 0 then v end order by 1)) from td;
show trace;
select /*+ recompile no_parallel_scan */ count(distinct case when v < 0 then v end), sum(distinct case when v < 0 then v end), median(case when v < 0 then v end), length(group_concat(case when v < 0 then v end order by 1)) from td;
show trace;


evaluate 'Case 4: Only serial partition contributes; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(distinct case when id >= 1000000 and id < 2000000 then v end), sum(distinct case when id >= 1000000 and id < 2000000 then v end), cast(median(case when id >= 1000000 and id < 2000000 then v end) as numeric(20,6)) from td;
show trace;
select /*+ recompile no_parallel_scan */ count(distinct case when id >= 1000000 and id < 2000000 then v end), sum(distinct case when id >= 1000000 and id < 2000000 then v end), cast(median(case when id >= 1000000 and id < 2000000 then v end) as numeric(20,6)) from td;
show trace;


evaluate 'Case 5: Final parallel partition only; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(*), count(distinct v), sum(distinct v) from td where v >= 10000;
show trace;
select /*+ recompile no_parallel_scan */ count(*), count(distinct v), sum(distinct v) from td where v >= 10000;
show trace;


evaluate 'Case 6: Exactly one non-NULL serial value; result = NO_PARALLEL_SCAN';
select /*+ recompile */ count(distinct case when id = 1000001 then v end), sum(distinct case when id = 1000001 then v end), median(case when id = 1000001 then v end) from td;
show trace;
select /*+ recompile no_parallel_scan */ count(distinct case when id = 1000001 then v end), sum(distinct case when id = 1000001 then v end), median(case when id = 1000001 then v end) from td;
show trace;
set trace off;
set system parameters 'group_concat_max_len=default';
drop table td;
