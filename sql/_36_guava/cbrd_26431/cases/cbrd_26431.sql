/**
 *  This test case verifies CBRD-26431: COUNT(alias) on a subquery expression
 *  is rewritten incorrectly, returning 0 instead of the actual count. The bug occurs in CS-mode.
 *
 *  Coverage:
 *    1. Ticket repro: RECOMPILE hint - parallel scan triggers, must return correct count
 *    2. Control: parallel(0) on the outer query does NOT disable the parallel
 *       scan (ticket example 2) - must still return the correct count
 *    3. Control: parallel(0) inside the subquery takes the serial path -
 *       confirms the bug is parallel-scan-specific
 *    4. Different arithmetic expression (multiplication)
 *    5. Mixed expression and plain column aliases
 *    6. Other aggregates (SUM/AVG) on expression alias
 *    7. Nested subquery with expression alias
 *    8. NULL-producing expression alias - COUNT(expr) must skip NULLs
 *    9. Simple column alias control - proves bug is expression-specific
 *   10. BIGINT expression alias under parallel scan
 *   11. NUMERIC(38,10) expression alias under parallel scan
 *   12. GROUP BY on expression alias - parallel list-gather path (breadth, not
 *       CBRD-26431 fix coverage since it uses BUILDLIST_PROC not BUILDVALUE_PROC)
 *   13. count(distinct expression alias) - covers Q_DISTINCT branch of the fix
 *   14. MIN and MAX on expression alias under parallel scan
 */

drop table if exists tbl;
create table tbl (col1 int, pad varchar(300));

-- insert 16696 rows; pad column inflates row size so heap pages reliably exceed
-- the parallel scan threshold (32 pages)
insert into tbl
select rownum, lpad('x', 300, 'x')
from table({0,1,2,3,4,5,6,7,8,9}) a,
     table({0,1,2,3,4,5,6,7,8,9}) b,
     table({0,1,2,3,4,5,6,7,8,9}) c,
     table({0,1,2,3,4,5,6,7,8,9}) d,
     table({0,1,2,3,4,5,6,7,8,9}) e,
     table({0,1,2,3,4,5,6,7,8,9}) f
limit 16696;

set trace on;

evaluate 'Case 1: RECOMPILE hint - count(alias) on expression alias (parallel path)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from tbl) x;
show trace;

evaluate 'Case 2: RECOMPILE parallel(0) on outer query (parallel)';
select /*+ RECOMPILE parallel(0) */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from tbl) x;
show trace;

evaluate 'Case 3: RECOMPILE parallel(0) inside subquery (serial path)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select /*+ RECOMPILE parallel(0) */ col1 + col1 as s from tbl) x;
show trace;

evaluate 'Case 4: different arithmetic expression (multiplication)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 * 2 as s from tbl) x;
show trace;

evaluate 'Case 5: mixed expression and plain column aliases';
select /*+ RECOMPILE */ count(x.s), count(x.c), count(*)
from (select col1 + col1 as s, col1 as c from tbl) x;
show trace;

evaluate 'Case 6: other aggregates on expression alias - SUM and AVG';
select /*+ RECOMPILE */ sum(x.s), avg(x.s)
from (select col1 + 0 as s from tbl where col1 <= 3) x;
show trace;

evaluate 'Case 7: nested subquery with expression alias';
select /*+ RECOMPILE */ count(y.v)
from (
  select x.s + 1 as v
  from (select col1 + col1 as s from tbl) x
) y;
show trace;

evaluate 'Case 8: NULL-producing expression alias - COUNT skips NULLs correctly';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (
  select case when col1 = 1 then null else col1 + col1 end as s
  from tbl
) x;
show trace;

evaluate 'Case 9: simple column alias control - no arithmetic expression';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 as s from tbl) x;
show trace;

evaluate 'Case 10: BIGINT expression alias under parallel scan';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 * cast(1000000000 as bigint) as s from tbl) x;
show trace;

evaluate 'Case 11: NUMERIC(38,10) expression alias under parallel scan';
select /*+ RECOMPILE */ count(x.s), sum(x.s)
from (select cast(col1 as numeric(38,10)) / 3 as s from tbl where col1 <= 3) x;
show trace;

evaluate 'Case 12: GROUP BY on expression alias, count(expr) per group (parallel list-gather path)';
select /*+ RECOMPILE */ x.g, count(x.s)
from (select col1 % 4 as g, col1 + col1 as s from tbl) x
group by x.g order by x.g;
show trace;

evaluate 'Case 13: count(distinct expression alias)';
select /*+ RECOMPILE */ count(distinct x.s)
from (select col1 % 100 as s from tbl) x;
show trace;

evaluate 'Case 14: MIN and MAX on expression alias under parallel scan';
select /*+ RECOMPILE */ min(x.s), max(x.s)
from (select col1 + col1 as s from tbl) x;
show trace;

set trace off;

drop table tbl;
