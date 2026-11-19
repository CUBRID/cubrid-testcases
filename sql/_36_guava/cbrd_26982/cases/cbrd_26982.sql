/**
 * This test case verifies CBRD-26982 : the buildvalue optimization of the
 * parallel heap scan (GROUP BY-less aggregate, "gather: buildvalue") no longer
 * requires the select list to map 1:1 onto the aggregate list.
 *
 * Before: the eligibility check demanded agg_cnt == valptr_cnt, so a query
 * whose output column count differed from its aggregate count, e.g.
 * SUM(a) / COUNT(*) (2 aggregates, 1 column) or x, SUM(a) (1 aggregate,
 * 2 columns), fell back to the slower "gather: row by row" path.
 *
 * Fix (engine PR #7355): the check was removed. Workers merge their partial
 * aggregates into the main XASL, and the normal end-of-scan code finalizes the
 * aggregates, evaluates HAVING and projects the select list exactly as the
 * serial path does.
 *
 * cbrd_26711 Case 16 already covers one non-1:1 shape (COUNT(*), SUM(col),
 * x: aggregates followed by a constant). This case covers the remaining
 * shapes: several aggregates combined into one column, a leading constant,
 * HAVING (true and false), an empty input, and the CBRD-26846 list-based
 * aggregates (MEDIAN, GROUP_CONCAT) inside expressions. Cases 10 to 13 run
 * the same change through DISTINCT aggregates combined into columns and in
 * HAVING, bound values in the select list and HAVING of a prepared query,
 * and a non-1:1 aggregate query used as a derived table. Case 14 keeps a 1:1
 * query with scalar expressions over its aggregates on the buildvalue path.
 *
 * Each parallel query runs under trace so the answer pins "gather: buildvalue".
 * It is followed by the same query with NO_PARALLEL_SCAN, whose result must be
 * identical. The values are deterministic: a and b take 1..10, 1000 rows each.
 * Names have no digits so CTP does not mask them.
 *
 * Coverage (aggregates / output columns; an aggregate in HAVING is a separate
 * entry of the aggregate list):
 *   Case 1: SUM(a) / COUNT(*)                                   (2 / 1)
 *   Case 2: SUM(a) + COUNT(*), MAX(b)                           (3 / 2)
 *   Case 3: x, SUM(a), COUNT(*), 42                             (2 / 4)
 *   Case 4: (SUM(a) + SUM(b)) / COUNT(*)                        (3 / 1)
 *   Case 5: SUM(a) HAVING SUM(a) > 0                            (2 / 1), one row
 *   Case 6: SUM(a) HAVING SUM(a) < 0                            (2 / 1), no row
 *   Case 7: COUNT(*), MAX(a), tag over no matching row          (2 / 3)
 *   Case 8: MEDIAN(a) * 2, MAX(b) - MIN(a), group_concat length (5 / 3)
 *   Case 9: SUM(a) HAVING SUM(a) > 50000                        (2 / 1), one row: true
 *           only for the final sum 55000, never for a partial sum of a worker
 *   Case 10: SUM(DISTINCT a) * 100 + COUNT(DISTINCT b),
 *            AVG(DISTINCT a) * 2                                (3 / 2)
 *   Case 11: COUNT(*) HAVING SUM(DISTINCT a) = 55               (2 / 1), one row
 *   Case 12: prepared SUM(a) * bound value HAVING SUM(a) > bound value
 *                                                               (2 / 1), one row
 *            for 50000 and no row for 60000
 *   Case 13: SUM(a) / COUNT(*) as a derived table, read by an outer query
 *            that adds a constant                               (2 / 1 inside)
 *   Case 14: COUNT(*) + 1, SUM(a) * 2                           (2 / 2), a 1:1
 *            query that ran with buildvalue before the fix too and still does
 */

drop table if exists tg;
-- 10000 rows with two md5 strings each (incompressible): about 70 heap pages,
-- past the parallel heap scan threshold of 32 pages that CTP test_mode=yes sets,
-- so that every scan of tg runs in parallel
create table tg (a int, b int, s varchar(80));
insert into tg
select rownum % 10 + 1, (rownum * 7) % 10 + 1, concat(md5(rownum), md5(rownum + 7919))
from db_class x, db_class y, db_class z, db_class w limit 10000;

set trace on;

evaluate 'Case 1: SUM(a) / COUNT(*)  (2 aggregates, 1 column)';
select /*+ recompile PARALLEL(8) */ sum(a) / count(*) from tg;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(a) / count(*) from tg;

evaluate 'Case 2: SUM(a) + COUNT(*), MAX(b)  (3 aggregates, 2 columns)';
select /*+ recompile PARALLEL(8) */ sum(a) + count(*), max(b) from tg;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(a) + count(*), max(b) from tg;

evaluate 'Case 3: leading and trailing constants  (2 aggregates, 4 columns)';
select /*+ recompile PARALLEL(8) */ 'x', sum(a), count(*), 42 from tg;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ 'x', sum(a), count(*), 42 from tg;

evaluate 'Case 4: (SUM(a) + SUM(b)) / COUNT(*)  (3 aggregates, 1 column)';
select /*+ recompile PARALLEL(8) */ (sum(a) + sum(b)) / count(*) from tg;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ (sum(a) + sum(b)) / count(*) from tg;

evaluate 'Case 5: HAVING that keeps the row  (2 aggregates, 1 column)';
select /*+ recompile PARALLEL(8) */ sum(a) from tg having sum(a) > 0;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(a) from tg having sum(a) > 0;

evaluate 'Case 6: HAVING that removes the row  (2 aggregates, 1 column)';
select /*+ recompile PARALLEL(8) */ sum(a) from tg having sum(a) < 0;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(a) from tg having sum(a) < 0;

evaluate 'Case 7: no matching row, aggregates plus a constant';
select /*+ recompile PARALLEL(8) */ count(*), max(a), 'tag' from tg where b > 100;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ count(*), max(a), 'tag' from tg where b > 100;

evaluate 'Case 8: list-based aggregates inside expressions  (5 aggregates, 3 columns)';
select /*+ recompile PARALLEL(8) */ cast(median(a) * 2 as int), max(b) - min(a),
       length(group_concat(distinct b order by b separator ',')) + count(*) from tg;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ cast(median(a) * 2 as int), max(b) - min(a),
       length(group_concat(distinct b order by b separator ',')) + count(*) from tg;

evaluate 'Case 9: HAVING true only for the final sum 55000 > 50000  (2 aggregates, 1 column)';
select /*+ recompile PARALLEL(8) */ sum(a) from tg having sum(a) > 50000;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(a) from tg having sum(a) > 50000;
select case when (select count(*) from (select /*+ recompile PARALLEL(8) */ sum(a) sa from tg having sum(a) > 50000) p
                   where p.sa = 55000) = 1
             and (select count(*) from (select /*+ recompile NO_PARALLEL_SCAN */ sum(a) sa from tg having sum(a) > 50000) s
                   where s.sa = 55000) = 1
            then 'PASS' else 'FAIL' end as case9;

-- each worker sees all ten values of a and b, so a DISTINCT result that adds the
-- partial results of the workers is a multiple of the right one
evaluate 'Case 10: DISTINCT aggregates combined into columns  (3 aggregates, 2 columns)';
select /*+ recompile PARALLEL(8) */ sum(distinct a) * 100 + count(distinct b), cast(avg(distinct a) * 2 as int) from tg;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(distinct a) * 100 + count(distinct b), cast(avg(distinct a) * 2 as int) from tg;
show trace;

evaluate 'Case 11: HAVING on a DISTINCT aggregate keeps the row  (2 aggregates, 1 column)';
select /*+ recompile PARALLEL(8) */ count(*) from tg having sum(distinct a) = 55;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ count(*) from tg having sum(distinct a) = 55;

-- the bound values are evaluated once, after the workers merge their partial sums;
-- the second execute of each query reuses its cached plan, whose trace has no plan text.
-- A trace prints the plan text of every query compiled since the last show trace,
-- so each execute is followed by its own show trace
evaluate 'Case 12: bound values in the select list and HAVING of a prepared query  (2 aggregates, 1 column)';
prepare q_par from 'select /*+ PARALLEL(8) */ sum(a) * ? from tg having sum(a) > ?';
prepare q_ser from 'select /*+ NO_PARALLEL_SCAN */ sum(a) * ? from tg having sum(a) > ?';
execute q_par using 2, 50000;
show trace;
execute q_ser using 2, 50000;
show trace;
execute q_par using 2, 60000;
show trace;
execute q_ser using 2, 60000;
show trace;
deallocate prepare q_par;
deallocate prepare q_ser;

evaluate 'Case 13: a non-1:1 aggregate query as a derived table  (2 aggregates, 1 column inside)';
select v.r, 'tag' from (select /*+ recompile PARALLEL(8) */ sum(a) / count(*) r from tg) v;
show trace;
select v.r, 'tag' from (select /*+ recompile NO_PARALLEL_SCAN */ sum(a) / count(*) r from tg) v;

-- one column per aggregate: the removed check let this shape through before the fix as well
evaluate 'Case 14: scalar expressions over single aggregates  (2 aggregates, 2 columns)';
select /*+ recompile PARALLEL(8) */ count(*) + 1, sum(a) * 2 from tg;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ count(*) + 1, sum(a) * 2 from tg;

set trace off;

drop table if exists tg;
