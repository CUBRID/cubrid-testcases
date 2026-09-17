/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: parallel hash join hints
 * Description: The parallel-hash-join hints behave as intended - partitioning drives whether a
 *              parallel hash join runs, NO_PARALLEL_HASH_JOIN forces a single-threaded partition
 *              hash join, and PARALLEL(N) sets the degree (0 disables, invalid values are clamped).
 *              Note: on this build the PROBE phase is parallelized even when no partitioning is
 *              needed (parallel probe), so scenario 1 still shows parallel workers on PROBE while
 *              the hash join itself is not partitioned/parallel.
 * Coverage: PR#6247 partition-driven parallel hash join / NO_PARALLEL_HASH_JOIN / PARALLEL(N)
 * Not covered here (asserted in shell instead): the CTP SQL framework normalizes every trace
 *           integer to '?', so this file can only assert that a PARALLEL / SPLIT node is present,
 *           never the numbers. The exact parallel degree, the PARALLEL(N) clamp boundaries and the
 *           partition count are asserted from raw csql trace output by the shell testcase
 *           cbrd_25717_parallel_degree.sh (shell/_40_guava/cbrd_25717).
 * Source: JIRA attachment cbrd-25717_test-case_20260811.zip (adapted)
 */

--
-- test data
--

drop table if exists t_px_hint;

create table t_px_hint (ckey int);

insert into t_px_hint
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum from cte a, cte b limit 100000;

set trace on;


evaluate 'Case 1: no partitioning needed -> parallel hash join not performed (parallel probe is the exception)';

-- set the default explicitly so the 'no partition' baseline holds regardless of run order
set system parameters 'max_hash_list_scan_size=default';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery */
  count (*)
from t_px_hint a, t_px_hint b
where a.ckey = b.ckey;

show trace;


evaluate 'Case 2: partitioning needed -> parallel hash join performed';

-- lower max_hash_list_scan_size so a partition hash join is required
set system parameters 'max_hash_list_scan_size=256k';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery */
  count (*)
from t_px_hint a, t_px_hint b
where a.ckey = b.ckey;

show trace;


evaluate 'Case 3: NO_PARALLEL_HASH_JOIN forces single-threaded even when partitioning is needed';

set system parameters 'max_hash_list_scan_size=256k';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery
           no_parallel_hash_join */
  count (*)
from t_px_hint a, t_px_hint b
where a.ckey = b.ckey;

show trace;


evaluate 'Case 4: PARALLEL(0) -> degree below 2 -> parallel hash join not requested';

set system parameters 'max_hash_list_scan_size=256k';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery
           parallel(0) */
  count (*)
from t_px_hint a, t_px_hint b
where a.ckey = b.ckey;

show trace;


evaluate 'Case 5: parallelism exceeds the partition count -> parallel hash join still performed';

set system parameters 'max_hash_list_scan_size=256k';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery
           parallel(32) */
  count (*)
from t_px_hint a, t_px_hint b
where a.ckey = b.ckey;

show trace;


evaluate 'Case 6: PARALLEL(-1000) -> negative degree clamped to 0, same path as Case 4';

set system parameters 'max_hash_list_scan_size=256k';

select /*+ recompile
           use_hash
           no_parallel_scan
           no_parallel_subquery
           parallel(-1000) */
  count (*)
from t_px_hint a, t_px_hint b
where a.ckey = b.ckey;

show trace;


--
-- clean up test data
--

drop table t_px_hint;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
