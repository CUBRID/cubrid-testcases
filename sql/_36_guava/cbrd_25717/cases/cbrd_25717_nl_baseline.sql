/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: nested-loop baseline for the parallel hash join result
 * Coverage: CBRD-25717 A/C (2) requires the parallel result to be logically identical to a
 *           single hash join OR to a nested loop join. The suite already compared
 *           single / partition / parallel hash paths against each other, but never against NL,
 *           so the "or NL" half of the acceptance criterion had no evidence. All four join
 *           strategies are run here over the same data and must agree exactly.
 * How verified: NL == single hash == partition hash == parallel hash, on count and on two
 *           checksums. Every case emits SQL Trace so the answer file records which strategy each
 *           case actually used - a hint that silently failed to take effect would otherwise turn
 *           this into four copies of the same plan agreeing with itself.
 * Note: the dataset is deliberately small (2000 x 2000). NL is O(n*m) and the issue's own
 *       performance table shows it is the worst strategy, so a 100000-row NL would be unusable
 *       in a regression suite. Correctness of the large parallel path is already covered by the
 *       other files; all this case needs to establish is logical equivalence.
 *       max_hash_list_scan_size is lowered to 4k for the partition/parallel cases so that even
 *       this small input is split, then restored for the single-hash case.
 * Source: own addition (not in the JIRA attachment) - closes the "or NL" half of A/C (2).
 */

--
-- test data
--

drop table if exists t_nl1, t_nl2;

create table t_nl1 (c1 int, c2 int);
create table t_nl2 (c1 int, c2 int);

insert into t_nl1
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select n, mod (n, 7) from cte;

insert into t_nl2
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select n, mod (n, 5) from cte;

update statistics on t_nl1, t_nl2;

set trace on;


evaluate 'Case 1: NESTED LOOP baseline (USE_NL) - the reference result';

select /*+ recompile ordered use_nl no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.c1 as bigint)) as s1, sum (b.c2) as s2
from t_nl1 a, t_nl2 b
where a.c1 = b.c1;

show trace;

evaluate 'Case 2: single hash join (no partitioning - default scan size) - must match Case 1';

set system parameters 'max_hash_list_scan_size=default';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.c1 as bigint)) as s1, sum (b.c2) as s2
from t_nl1 a, t_nl2 b
where a.c1 = b.c1;

show trace;

evaluate 'Case 3: partition hash join, single-threaded (scan size lowered) - must match Case 1';

set system parameters 'max_hash_list_scan_size=4k';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.c1 as bigint)) as s1, sum (b.c2) as s2
from t_nl1 a, t_nl2 b
where a.c1 = b.c1;

show trace;

evaluate 'Case 4: PARALLEL partition hash join - must match Case 1';

select /*+ recompile use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.c1 as bigint)) as s1, sum (b.c2) as s2
from t_nl1 a, t_nl2 b
where a.c1 = b.c1;

show trace;

set trace off;

--
-- clean up test data
--

drop table t_nl1, t_nl2;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
