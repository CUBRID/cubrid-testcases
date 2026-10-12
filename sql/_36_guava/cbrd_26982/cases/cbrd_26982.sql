/*
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
 * aggregates (MEDIAN, GROUP_CONCAT) inside expressions.
 *
 * Each parallel query runs under trace so the answer pins "gather: buildvalue".
 * It is followed by the same query with NO_PARALLEL_SCAN, whose result must be
 * identical. The values are deterministic: a and b take 1..10, 1000 rows each.
 *
 * Table sizing: 10000 rows with two md5 strings each (incompressible) give
 * about 70 heap pages, above the parallel scan threshold that the CTP
 * test_mode=yes sets (32 pages). Names have no digits so CTP does not mask
 * them.
 *
 * Coverage (aggregates / output columns):
 *   Case 1: SUM(a) / COUNT(*)                         (2 / 1)
 *   Case 2: SUM(a) + COUNT(*), MAX(b)                  (3 / 2)
 *   Case 3: x, SUM(a), COUNT(*), 42                  (2 / 4)
 *   Case 4: (SUM(a) + SUM(b)) / COUNT(*)               (3 / 1)
 *   Case 5: SUM(a), has HAVING SUM(a) > 0            (1 / 2), one row
 *   Case 6: SUM(a), none HAVING SUM(a) < 0           (1 / 2), no row
 *   Case 7: COUNT(*), MAX(a), tag over no matching row (2 / 3)
 *   Case 8: MEDIAN(a) * 2, MAX(b) - MIN(a), group_concat length (5 / 3)
 */

drop table if exists tg;
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

evaluate 'Case 5: HAVING that keeps the row';
select /*+ recompile PARALLEL(8) */ sum(a), 'has' from tg having sum(a) > 0;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(a), 'has' from tg having sum(a) > 0;

evaluate 'Case 6: HAVING that removes the row';
select /*+ recompile PARALLEL(8) */ sum(a), 'none' from tg having sum(a) < 0;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ sum(a), 'none' from tg having sum(a) < 0;

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

set trace off;

drop table if exists tg;
