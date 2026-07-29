/**
 *  This test case verifies CBRD-26431: COUNT(alias) on a subquery expression
 *  is rewritten incorrectly, returning 0 instead of the actual count. The bug occurs in CS-mode.
 *
 *  Coverage:
 *    1-3. Ticket repro: three hint combinations (RECOMPILE, RECOMPILE parallel(0),
 *         parallel(0) inside subquery) - all must return correct count
 *    4. Boundary: 16695 rows (below threshold)
 *    5. Boundary: 16696 rows via WHERE filter
 *    6. Different arithmetic expression (multiplication)
 *    7. Mixed expression and plain column aliases
 *    8. Other aggregates (SUM/AVG) on expression alias
 *    9. Nested subquery with expression alias
 *   10. NULL-producing expression alias - COUNT(expr) must skip NULLs
 *   11. Simple column alias control - proves bug is expression-specific
 */

drop table if exists t1;
create table t1 (col1 int);

-- insert 16696 rows (the threshold where the bug manifests)
insert into t1
select rownum
from table({0,1,2,3,4,5,6,7,8,9}) a,
     table({0,1,2,3,4,5,6,7,8,9}) b,
     table({0,1,2,3,4,5,6,7,8,9}) c,
     table({0,1,2,3,4,5,6,7,8,9}) d,
     table({0,1,2,3,4,5,6,7,8,9}) e,
     table({0,1,2,3,4,5,6,7,8,9}) f
limit 16696;

evaluate 'Case 1: RECOMPILE hint - count(alias) on expression alias';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from t1) x;

evaluate 'Case 2: RECOMPILE parallel(0) hint on outer query';
select /*+ RECOMPILE parallel(0) */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from t1) x;

evaluate 'Case 3: RECOMPILE parallel(0) hint inside subquery';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select /*+ RECOMPILE parallel(0) */ col1 + col1 as s from t1) x;

evaluate 'Case 4: boundary - 16695 rows (just below threshold)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from t1 where col1 <= 16695) x;

evaluate 'Case 5: boundary - 16696 rows via WHERE filter';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from t1 where col1 <= 16696) x;

evaluate 'Case 6: different arithmetic expression (multiplication)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 * 2 as s from t1) x;

evaluate 'Case 7: mixed expression and plain column aliases';
select /*+ RECOMPILE */ count(x.s), count(x.c), count(*)
from (select col1 + col1 as s, col1 as c from t1) x;

evaluate 'Case 8: other aggregates on expression alias - SUM and AVG';
select /*+ RECOMPILE */ sum(x.s), avg(x.s)
from (select col1 + 0 as s from t1 where col1 <= 3) x;

evaluate 'Case 9: nested subquery with expression alias';
select /*+ RECOMPILE */ count(y.v)
from (
  select x.s + 1 as v
  from (select col1 + col1 as s from t1) x
) y;

evaluate 'Case 10: NULL-producing expression alias - COUNT skips NULLs correctly';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (
  select case when col1 = 1 then null else col1 + col1 end as s
  from t1
) x;

evaluate 'Case 11: simple column alias control - no arithmetic expression';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 as s from t1) x;

drop table t1;
