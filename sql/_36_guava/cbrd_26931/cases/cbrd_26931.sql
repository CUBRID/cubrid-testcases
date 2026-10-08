/**
 *  This test case verifies CBRD-26931: the scans inside an uncorrelated scalar subquery run in parallel,
 *  and a parallel outer scan gets the subquery value once instead of running it in every worker.
 *
 *  CBRD-26722 kept every subquery that feeds an expression out of parallel scan, so the big scan in a
 *  WHERE scalar subquery (TPC-H Q15) ran in one thread. Engine PR #7316 evaluates such a subquery once
 *  before the outer scan opens, copies the value into the workers and lets its inner scans go parallel.
 *
 *  Each tested query is followed by a twin with no_parallel_scan in every query block and the same result.
 *  CTP masks digits, so the trace asserts the parallel workers line, and a serial counts the runs.
 *
 *  Coverage:
 *    Case 1:  TPC-H Q15 shape with GROUP BY derived tables, result = twin
 *    Case 2:  Q15 shape with aggregate derived tables, FROM and WHERE scans both parallel
 *    Case 3:  WHERE operand, parallel heap scan inside the subquery
 *    Case 4:  parallel index scan inside the subquery
 *    Case 5:  three nested scalar subqueries, each scan parallel
 *    Case 6:  select-list operand parallel, a bare select-list subquery stays serial
 *    Case 7:  CASE operand and HAVING without GROUP BY
 *    Case 8:  DELETE, UPDATE and INSERT SELECT with the subquery in WHERE
 *    Case 9:  CTE read twice under UNION ALL
 *    Case 10: correlated, uncorrelated inside correlated and ALL subqueries stay serial
 *    Case 11: NO_PARALLEL_SCAN and PARALLEL(0) inside the subquery keep it serial
 *    Case 12: parallel outer scan reading an int value and a NULL value
 *    Case 13: varchar, datetime and numeric values, two subqueries in BETWEEN
 *    Case 14: parallel outer scan gathered as a list (ORDER BY)
 *    Case 15: outer scan and subquery scan both parallel
 *    Case 16: nested loop join with the subquery on the inner table, result = twin
 *    Case 17: a serial in the subquery advances by one per query under a parallel outer scan
 */

drop table if exists t_big, t_small, t_target;
drop serial if exists s_once;

-- 100000 rows of seven columns span far more than the 32 pages test_mode needs for a parallel heap scan.
-- v has no index, so max(v) scans the heap; w has an index for the parallel index scan of Case 4
create table t_big (k int primary key, g int, v int, w int, s varchar(16), d datetime, n numeric(12,2));
insert into t_big select rownum, mod(rownum, 7), mod(rownum * 37, 1000), mod(rownum, 1000), 'str' || lpad(mod(rownum, 1000), 4, '0'), datetime '2026-01-01 00:00:00' + mod(rownum, 1000) * 1000, mod(rownum, 1000) / 4.0 from db_class a, db_class b, db_class c, db_class d limit 100000;
create index i_big_w on t_big (w);
-- three rows, never scanned in parallel: the outer side and the source of the injected values
create table t_small (g int, v int, s varchar(16), d datetime, n numeric(12,2));
insert into t_small values (0, 10, 'str0010', datetime '2026-01-01 00:00:10', 2.50), (1, 500, 'str0500', datetime '2026-01-01 00:08:20', 125.00), (2, 990, 'str0990', datetime '2026-01-01 00:16:30', 247.50);
-- DML target of Case 8
create table t_target (a int, b int);
insert into t_target values (10, 100), (20, 200);
-- counts the executions of the subquery in Case 17
create serial s_once;
update statistics on t_big, t_small, t_target with fullscan;

set trace on;


evaluate 'Case 1: Q15 shape with GROUP BY derived tables; result = no_parallel_scan';
select /*+ recompile */ dt.g, dt.total from (select g, sum(v) total from t_big group by g) dt where dt.total = (select max(total) from (select g, sum(v) total from t_big group by g) dv) order by dt.g;
select /*+ recompile no_parallel_scan */ dt.g, dt.total from (select /*+ no_parallel_scan */ g, sum(v) total from t_big group by g) dt where dt.total = (select /*+ no_parallel_scan */ max(total) from (select /*+ no_parallel_scan */ g, sum(v) total from t_big group by g) dv) order by dt.g;


evaluate 'Case 2: Q15 shape with aggregate derived tables, both scans parallel; result = no_parallel_scan';
select /*+ recompile */ dt.total from (select sum(v) total from t_big where g = 3) dt where dt.total = (select max(total) from (select sum(v) total from t_big where g = 3) dv);
show trace;
select /*+ recompile no_parallel_scan */ dt.total from (select /*+ no_parallel_scan */ sum(v) total from t_big where g = 3) dt where dt.total = (select /*+ no_parallel_scan */ max(total) from (select /*+ no_parallel_scan */ sum(v) total from t_big where g = 3) dv);


evaluate 'Case 3: WHERE operand, parallel heap scan inside; result = no_parallel_scan';
select /*+ recompile */ g, v from t_small where v >= (select avg(v) from t_big) order by g;
show trace;
select /*+ recompile */ g, v from t_small where v >= (select /*+ no_parallel_scan */ avg(v) from t_big) order by g;


evaluate 'Case 4: parallel index scan inside; result = no_parallel_scan';
select /*+ recompile */ g, v from t_small where v * 100 <= (select count(*) from t_big force index (i_big_w) where w >= 500) order by g;
show trace;
select /*+ recompile */ g, v from t_small where v * 100 <= (select /*+ no_parallel_scan */ count(*) from t_big force index (i_big_w) where w >= 500) order by g;


evaluate 'Case 5: three nested scalar subqueries; result = no_parallel_scan';
select /*+ recompile */ g, v from t_small where v <= (select max(v) from t_big where v < (select max(v) from t_big where v < (select avg(v) from t_big))) order by g;
show trace;
select /*+ recompile */ g, v from t_small where v <= (select /*+ no_parallel_scan */ max(v) from t_big where v < (select /*+ no_parallel_scan */ max(v) from t_big where v < (select /*+ no_parallel_scan */ avg(v) from t_big))) order by g;


evaluate 'Case 6: select-list operand parallel, bare select-list subquery serial; result = no_parallel_scan';
select /*+ recompile */ (select max(v) from t_big) + 0 from db_root;
show trace;
select /*+ recompile */ (select max(v) from t_big) from db_root;
show trace;
select /*+ recompile */ (select /*+ no_parallel_scan */ max(v) from t_big) + 0 from db_root;


evaluate 'Case 7: CASE operand and HAVING without GROUP BY; result = no_parallel_scan';
select /*+ recompile */ g, case when v < (select avg(v) from t_big) then 'below' else 'above' end from t_small order by g;
show trace;
select /*+ recompile */ g, case when v < (select /*+ no_parallel_scan */ avg(v) from t_big) then 'below' else 'above' end from t_small order by g;
select /*+ recompile */ count(*), sum(v) from t_small having max(v) > (select avg(v) from t_big);
show trace;
select /*+ recompile */ count(*), sum(v) from t_small having max(v) > (select /*+ no_parallel_scan */ avg(v) from t_big);


evaluate 'Case 8: DELETE, UPDATE and INSERT SELECT; result = no_parallel_scan';
delete /*+ recompile */ from t_target where b > (select max(v) from t_big);
show trace;
delete /*+ recompile */ from t_target where b > (select /*+ no_parallel_scan */ max(v) from t_big);
update /*+ recompile */ t_target set b = b where b <= (select max(v) from t_big);
show trace;
update /*+ recompile */ t_target set b = b where b <= (select /*+ no_parallel_scan */ max(v) from t_big);
insert into t_target select /*+ recompile */ g, v from t_small where v <= (select max(v) from t_big);
show trace;
delete from t_target where a < 10;
insert into t_target select /*+ recompile */ g, v from t_small where v <= (select /*+ no_parallel_scan */ max(v) from t_big);
select a, b from t_target order by a, b;
delete from t_target where a < 10;


evaluate 'Case 9: CTE read twice under UNION ALL; result = no_parallel_scan';
with cte_small as (select g, v from t_small where v >= (select avg(v) from t_big)) select /*+ recompile */ g, v from cte_small union all select g, v from cte_small order by 1, 2;
show trace;
with cte_small as (select g, v from t_small where v >= (select /*+ no_parallel_scan */ avg(v) from t_big)) select /*+ recompile */ g, v from cte_small union all select g, v from cte_small order by 1, 2;


evaluate 'Case 10: correlated, uncorrelated inside correlated and ALL subqueries stay serial; result = no_parallel_scan';
select /*+ recompile */ ts.g from t_small ts where ts.v <= (select max(v) from t_big tb where tb.g = ts.g) order by ts.g;
show trace;
select /*+ recompile */ ts.g from t_small ts where ts.v <= (select /*+ no_parallel_scan */ max(v) from t_big tb where tb.g = ts.g) order by ts.g;
select /*+ recompile */ ts.g from t_small ts where ts.v <= (select max(tb.v) from t_big tb where tb.g = ts.g and tb.v < (select max(v) from t_big)) order by ts.g;
show trace;
select /*+ recompile */ ts.g from t_small ts where ts.v <= (select /*+ no_parallel_scan */ max(tb.v) from t_big tb where tb.g = ts.g and tb.v < (select /*+ no_parallel_scan */ max(v) from t_big)) order by ts.g;
select /*+ recompile */ g, v from t_small where v < all (select v from t_big where v > 995) order by g;
show trace;
select /*+ recompile */ g, v from t_small where v < all (select /*+ no_parallel_scan */ v from t_big where v > 995) order by g;


evaluate 'Case 11: NO_PARALLEL_SCAN and PARALLEL(0) inside the subquery keep it serial; result = without hint';
select /*+ recompile */ g, v from t_small where v >= (select /*+ no_parallel_scan */ avg(v) from t_big) order by g;
show trace;
select /*+ recompile */ g, v from t_small where v >= (select /*+ parallel(0) */ avg(v) from t_big) order by g;
show trace;
select /*+ recompile */ g, v from t_small where v >= (select avg(v) from t_big) order by g;


evaluate 'Case 12: parallel outer scan reading an int value and a NULL value; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(v), min(v), max(v) from t_big where v > (select avg(v) from t_small);
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(v), min(v), max(v) from t_big where v > (select avg(v) from t_small);
select /*+ recompile */ count(*) from t_big where v > (select v from t_small where g = 99);
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where v > (select v from t_small where g = 99);


evaluate 'Case 13: varchar, datetime, numeric and BETWEEN operands; result = no_parallel_scan';
select /*+ recompile */ count(*), min(w), max(w) from t_big where s >= (select s from t_small where g = 1);
show trace;
select /*+ recompile no_parallel_scan */ count(*), min(w), max(w) from t_big where s >= (select s from t_small where g = 1);
select /*+ recompile */ count(*), min(w), max(w) from t_big where d >= (select d from t_small where g = 0);
show trace;
select /*+ recompile no_parallel_scan */ count(*), min(w), max(w) from t_big where d >= (select d from t_small where g = 0);
select /*+ recompile */ count(*), min(w), max(w) from t_big where n > (select n from t_small where g = 2);
show trace;
select /*+ recompile no_parallel_scan */ count(*), min(w), max(w) from t_big where n > (select n from t_small where g = 2);
select /*+ recompile */ count(*), min(v), max(v) from t_big where v between (select min(v) from t_small) and (select max(v) from t_small);
show trace;
select /*+ recompile no_parallel_scan */ count(*), min(v), max(v) from t_big where v between (select min(v) from t_small) and (select max(v) from t_small);


evaluate 'Case 14: parallel outer scan gathered as a list; result = no_parallel_scan';
select /*+ recompile */ k, w from t_big where v = (select max(v) from t_small) and g = 3 order by k;
show trace;
select /*+ recompile no_parallel_scan */ k, w from t_big where v = (select max(v) from t_small) and g = 3 order by k;


evaluate 'Case 15: outer scan and subquery scan both parallel; result = no_parallel_scan';
select /*+ recompile */ count(*), min(k), max(k) from t_big where v >= (select max(v) from t_big) - 10;
show trace;
select /*+ recompile no_parallel_scan */ count(*), min(k), max(k) from t_big where v >= (select /*+ no_parallel_scan */ max(v) from t_big) - 10;


evaluate 'Case 16: nested loop join, subquery on the inner table; result = no_parallel_scan';
select /*+ recompile ordered use_nl */ ts.g, count(*), sum(tb.w) from t_big tb, t_small ts where ts.g = tb.g and ts.v >= (select max(v) from t_small where g = 1) group by ts.g order by ts.g;
select /*+ recompile ordered use_nl no_parallel_scan */ ts.g, count(*), sum(tb.w) from t_big tb, t_small ts where ts.g = tb.g and ts.v >= (select max(v) from t_small where g = 1) group by ts.g order by ts.g;


evaluate 'Case 17: a serial in the subquery advances by one per query; result = no_parallel_scan';
select /*+ recompile */ count(*) from t_big where v >= (select s_once.next_value from db_root) * 0;
show trace;
select s_once.current_value;
select /*+ recompile */ k, w from t_big where v >= (select s_once.next_value from db_root) * 0 and v = 990 and g = 3 order by k;
show trace;
select s_once.current_value;
select /*+ recompile */ count(*), max(v + (select s_once.next_value from db_root) * 0) from t_big;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select s_once.current_value;
select /*+ recompile no_parallel_scan */ count(*) from t_big where v >= (select s_once.next_value from db_root) * 0;
select s_once.current_value;

drop serial s_once;
drop table t_big, t_small, t_target;
