/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: two partition hash joins running in parallel within one plan
 * Coverage: every other case in the suite has exactly ONE hash join node per plan, so nothing
 *           exercises two parallel partition hash joins competing for the shared worker pool
 *           inside a single query. The click_count case does join three tables, but its plan is
 *           nested loops, not hash joins. This file joins three large tables so the plan carries
 *           two HASHJOIN nodes, both partitioned and both asking for workers - the shape where a
 *           bug in worker accounting, or in reusing split state across nodes, would surface.
 * How verified: every parallel case is paired with a single-threaded (no_parallel_hash_join) run
 *           of the same query - the results must be identical. Both runs emit SQL Trace, so the
 *           answer records how many HASHJOIN nodes the plan had and which of them got workers.
 * Note: t_mha and t_mhb hold keys 1..100000 while t_mhc holds only 1..90000, so the LEFT OUTER
 *       second join keeps 10000 rows that find no partner and must survive NULL-extended.
 *       The first join still matches fully. SUM is cast to
 *       BIGINT to avoid INT overflow, and every result is a single aggregate row, so no ORDER BY
 *       is needed for determinism.
 * Source: own addition (not in the JIRA attachment) - covers multi-node parallel hash join.
 */

--
-- test data
--

drop table if exists t_mha, t_mhb, t_mhc;

create table t_mha (ckey int, cval int);
create table t_mhb (ckey int, cval int);
create table t_mhc (ckey int, cval int);

insert into t_mha
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 7) from cte a, cte b limit 100000;

insert into t_mhb
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 5) from cte a, cte b limit 100000;

insert into t_mhc
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 3) from cte a, cte b limit 90000;

update statistics on t_mha, t_mhb, t_mhc;

-- lower the threshold so both joins take the partition (and parallel split) path
set system parameters 'max_hash_list_scan_size=256k';

set trace on;


evaluate 'Case 1: three-way join, both hash joins parallel';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.ckey as bigint)) as skey, sum (b.cval + c.cval) as sval
from t_mha a, t_mhb b, t_mhc c
where a.ckey = b.ckey and b.ckey = c.ckey;

show trace;

evaluate 'Case 2: same three-way join single-threaded - must match Case 1';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.ckey as bigint)) as skey, sum (b.cval + c.cval) as sval
from t_mha a, t_mhb b, t_mhc c
where a.ckey = b.ckey and b.ckey = c.ckey;

show trace;

evaluate 'Case 3: three-way with a LEFT OUTER as the second join - parallel';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (c.ckey) as matched
from t_mha a, t_mhb b
  left outer join t_mhc c on b.ckey = c.ckey
where a.ckey = b.ckey;

show trace;

evaluate 'Case 4: same three-way LEFT OUTER join single-threaded - must match Case 3';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (c.ckey) as matched
from t_mha a, t_mhb b
  left outer join t_mhc c on b.ckey = c.ckey
where a.ckey = b.ckey;

show trace;

set trace off;

--
-- clean up test data
--

drop table t_mha, t_mhb, t_mhc;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
