/**
 * This test case verifies CBRD-28390: a subquery that the workers of a parallel scan run again reads the result
 * of a CTE the statement made
 * Description: The workers of a parallel scan run a copy of the plan. A subquery they run again that reads a CTE
 *              must read the result the leader made, not the empty result of the copy (before the fix: 0 rows,
 *              or NULL for Case 3).
 *              Case 1: IN subquery under OR
 *              Case 2: scalar subquery in a condition pushed into the input of a hash join
 *              Case 3: scalar subquery alone in the select list
 *              The table is large enough for a parallel scan; each query is followed by its PARALLEL(0) twin,
 *              whose result must be the same.
 * Coverage: user CTE read by subqueries run again by the workers of a parallel scan
 */

--
-- test data
--

drop table if exists t_28390_t;
drop table if exists t_28390_u;

create table t_28390_t (k int, x int);
insert into t_28390_t select mod(level, 1000), mod(level, 97) from db_root connect by level <= 300000;
create table t_28390_u (k int, y int);
insert into t_28390_u select mod(level, 1000), mod(level, 89) from db_root connect by level <= 300000;
update statistics on t_28390_t, t_28390_u with fullscan;

--
-- test cases
--

evaluate 'Case 1: IN subquery under OR run again by the workers of a parallel scan (expected the same as PARALLEL(0))';
with c as (select k, sum(y) s from t_28390_u group by k)
select /*+ recompile parallel(4) */ count(*), sum(t.x)
from t_28390_t t, c a where t.k = a.k and (t.k in (select b.k from c b) or t.x = -1);
with c as (select k, sum(y) s from t_28390_u group by k)
select /*+ recompile parallel(0) */ count(*), sum(t.x)
from t_28390_t t, c a where t.k = a.k and (t.k in (select b.k from c b) or t.x = -1);

evaluate 'Case 2: scalar subquery in a condition pushed into the input of a hash join (expected the same as PARALLEL(0))';
with c as (select k, sum(y) s from t_28390_u group by k)
select /*+ recompile parallel(4) */ count(*), sum(t.x)
from t_28390_t t, c a where t.k = a.k and t.x >= (select min(b.s) / 1000 from c b);
with c as (select k, sum(y) s from t_28390_u group by k)
select /*+ recompile parallel(0) */ count(*), sum(t.x)
from t_28390_t t, c a where t.k = a.k and t.x >= (select min(b.s) / 1000 from c b);

evaluate 'Case 3: scalar subquery alone in the select list run by the workers of a parallel scan (expected no NULL)';
with c as (select k, sum(y) s from t_28390_u group by k)
select /*+ recompile parallel(4) */ t.k, (select max(b.s) from c b) sq, a.s
from t_28390_t t, c a where t.k = a.k and t.x = 7 and t.k < 3 order by 1, 2, 3;
with c as (select k, sum(y) s from t_28390_u group by k)
select /*+ recompile parallel(0) */ t.k, (select max(b.s) from c b) sq, a.s
from t_28390_t t, c a where t.k = a.k and t.x = 7 and t.k < 3 order by 1, 2, 3;

--
-- clean up test data
--

drop table t_28390_t;
drop table t_28390_u;
