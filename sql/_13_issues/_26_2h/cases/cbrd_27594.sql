/**
 *  This test case verifies CBRD-27594: NO_PARALLEL_SCAN and PARALLEL(n) apply to the temp scan
 *  that reads a materialized CTE result, as they do to the temp scan of a no_merge derived table.
 *
 *  Before the fix the hints of the block that references the CTE never reached that scan, so it
 *  always ran with the automatic degree. Now each reference follows the hints of its own query
 *  block, and a hint in the CTE body still applies only to the scans of the body.
 *
 *  A serial temp scan prints no parallel workers line under its SCAN (temp ...) line, and a
 *  parallel one prints that line with gather: buildvalue. CTP masks the digits, so only the line
 *  is asserted. Each query is followed by its twin over a no_merge derived table with the same
 *  hints, and every result is 100000 rows with sum(v) 49950000.
 *
 *  Coverage:
 *    Case 1:  NO_PARALLEL_SCAN on the outer query, the reported query
 *    Case 2:  NO_PARALLEL_SCAN on the CTE body and on the outer query
 *    Case 3:  NO_PARALLEL_SCAN on the CTE body only, the temp scan stays parallel
 *    Case 4:  no hint, the temp scan runs in parallel (positive control)
 *    Case 5:  PARALLEL(0) and PARALLEL(1) on the outer query
 *    Case 6:  PARALLEL(2) on the outer query
 *    Case 7:  two UNION ALL arms read the CTE with different hints
 *    Case 8:  a derived table that reads the CTE carries the hint, the outer query does not
 *    Case 9:  two references joined by a hash join in one block with NO_PARALLEL_SCAN
 *    Case 10: INSERT ... WITH ... SELECT with NO_PARALLEL_SCAN in the SELECT
 */

drop table if exists n_digit, t_heap, t_ins;

-- ten digits to build 100,000 rows by a cross join
create table n_digit (i int);
insert into n_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 100,000 rows with an incompressible 128-character pad: the CTE result list has about 930 pages,
-- 29x the parallel scan threshold of 32 pages under CTP; sum(v) = 100 * (0 + ... + 999) = 49950000
create table t_heap (id int, g int, v int, pad varchar(128));
insert into t_heap select rownum, mod(rownum, 100), mod(rownum, 1000), sha2(rownum, 512) from n_digit n_a, n_digit n_b, n_digit n_c, n_digit n_d, n_digit n_e;
-- target of the INSERT case
create table t_ins (id int, v int);
update statistics on n_digit, t_heap, t_ins with fullscan;

set trace on;


evaluate 'Case 1: NO_PARALLEL_SCAN on the outer query makes the CTE temp scan serial; result = derived table';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile no_parallel_scan */ count(*), sum(v) from c;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(v) from (select /*+ no_merge */ id, g, v, pad from t_heap) c;


evaluate 'Case 2: NO_PARALLEL_SCAN on the CTE body and on the outer query makes both scans serial; result = derived table';
with c as (select /*+ materialize no_parallel_scan */ id, g, v, pad from t_heap) select /*+ recompile no_parallel_scan */ count(*), sum(v) from c;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) c;


evaluate 'Case 3: NO_PARALLEL_SCAN on the CTE body only leaves the temp scan parallel; result = derived table';
with c as (select /*+ materialize no_parallel_scan */ id, g, v, pad from t_heap) select /*+ recompile */ count(*), sum(v) from c;
show trace;
select /*+ recompile */ count(*), sum(v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) c;


evaluate 'Case 4: without a hint the CTE temp scan runs in parallel; result = derived table';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile */ count(*), sum(v) from c;
show trace;
select /*+ recompile */ count(*), sum(v) from (select /*+ no_merge */ id, g, v, pad from t_heap) c;


evaluate 'Case 5: PARALLEL(0) and PARALLEL(1) on the outer query make the CTE temp scan serial; result = derived table';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile parallel(0) */ count(*), sum(v) from c;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(v) from (select /*+ no_merge */ id, g, v, pad from t_heap) c;
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile parallel(1) */ count(*), sum(v) from c;
show trace;
select /*+ recompile parallel(1) */ count(*), sum(v) from (select /*+ no_merge */ id, g, v, pad from t_heap) c;


evaluate 'Case 6: PARALLEL(2) on the outer query runs the CTE temp scan in parallel; result = derived table';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile parallel(2) */ count(*), sum(v) from c;
show trace;
select /*+ recompile parallel(2) */ count(*), sum(v) from (select /*+ no_merge */ id, g, v, pad from t_heap) c;


evaluate 'Case 7: each UNION ALL arm reads the CTE with its own hint, serial then parallel; result = derived tables';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile no_parallel_scan */ 'a' arm, count(*), sum(v) from c union all select /*+ parallel(2) */ 'b' arm, count(*), sum(v) from c order by 1;
show trace;
select /*+ recompile no_parallel_scan */ 'a' arm, count(*), sum(v) from (select /*+ no_merge */ id, g, v, pad from t_heap) c union all select /*+ parallel(2) */ 'b' arm, count(*), sum(v) from (select /*+ no_merge */ id, g, v, pad from t_heap) c order by 1;


evaluate 'Case 8: the hint of the derived table that reads the CTE makes its temp scan serial; result = derived tables';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile */ x.cnt, x.s from (select /*+ no_merge no_parallel_scan */ count(*) cnt, sum(v) s from c) x;
show trace;
select /*+ recompile */ x.cnt, x.s from (select /*+ no_merge no_parallel_scan */ count(*) cnt, sum(v) s from (select /*+ no_merge */ id, g, v, pad from t_heap) c) x;


evaluate 'Case 9: two CTE references joined by a hash join under NO_PARALLEL_SCAN are both scanned serially; result = derived tables';
with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile no_parallel_scan use_hash ordered */ count(*), sum(b.v) from c a, c b where a.id = b.id;
show trace;
select /*+ recompile no_parallel_scan use_hash ordered */ count(*), sum(b.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) a, (select /*+ no_merge */ id, g, v, pad from t_heap) b where a.id = b.id;


evaluate 'Case 10: NO_PARALLEL_SCAN in the SELECT of INSERT ... WITH ... SELECT makes the CTE temp scan serial; result = derived table';
insert into t_ins (id, v) with c as (select /*+ materialize */ id, g, v, pad from t_heap) select /*+ recompile no_parallel_scan */ id, v from c;
show trace;
-- trace goes off before the queries no show trace reads: the plan of a traced query left in the
-- session would be printed by the next show trace over a cached plan
set trace off;
select count(*), sum(v) from t_ins;
delete from t_ins;
insert into t_ins (id, v) select /*+ recompile no_parallel_scan */ id, v from (select /*+ no_merge */ id, g, v, pad from t_heap) c;
select count(*), sum(v) from t_ins;


drop table n_digit, t_heap, t_ins;
