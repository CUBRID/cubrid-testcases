/**
 *  This test case verifies CBRD-26431: COUNT(alias) on a subquery expression
 *  is rewritten incorrectly, returning 0 instead of the actual count. The bug occurs in CS-mode.
 *
 *  Coverage:
 *    1-3. Ticket repro: three hint combinations (RECOMPILE, RECOMPILE parallel(0),
 *         parallel(0) inside subquery) with trace to confirm parallel path
 *    4. Different arithmetic expression (multiplication)
 *    5. Mixed expression and plain column aliases
 *    6. Other aggregates (SUM/AVG) on expression alias
 *    7. Nested subquery with expression alias
 *    8. NULL-producing expression alias - COUNT(expr) must skip NULLs
 *    9. Simple column alias control - proves bug is expression-specific
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

set trace on;

evaluate 'Case 1: RECOMPILE hint - count(alias) on expression alias (parallel path)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from t1) x;
show trace;

evaluate 'Case 2: RECOMPILE parallel(0) on outer query (parallel)';
select /*+ RECOMPILE parallel(0) */ count(x.s), count(s), count(*)
from (select col1 + col1 as s from t1) x;
show trace;

evaluate 'Case 3: RECOMPILE parallel(0) inside subquery (serial path)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select /*+ RECOMPILE parallel(0) */ col1 + col1 as s from t1) x;
show trace;

evaluate 'Case 4: different arithmetic expression (multiplication)';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 * 2 as s from t1) x;
show trace;

evaluate 'Case 5: mixed expression and plain column aliases';
select /*+ RECOMPILE */ count(x.s), count(x.c), count(*)
from (select col1 + col1 as s, col1 as c from t1) x;
show trace;

evaluate 'Case 6: other aggregates on expression alias - SUM and AVG';
select /*+ RECOMPILE */ sum(x.s), avg(x.s)
from (select col1 + 0 as s from t1 where col1 <= 3) x;
show trace;

evaluate 'Case 7: nested subquery with expression alias';
select /*+ RECOMPILE */ count(y.v)
from (
  select x.s + 1 as v
  from (select col1 + col1 as s from t1) x
) y;
show trace;

evaluate 'Case 8: NULL-producing expression alias - COUNT skips NULLs correctly';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (
  select case when col1 = 1 then null else col1 + col1 end as s
  from t1
) x;
show trace;

evaluate 'Case 9: simple column alias control - no arithmetic expression';
select /*+ RECOMPILE */ count(x.s), count(s), count(*)
from (select col1 as s from t1) x;
show trace;

set trace off;

drop table t1;
