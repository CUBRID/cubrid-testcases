/*
 * CBRD-26719 - regression guard against re-entering the parallel probe from the PARTITION path
 *   covers: C8 (assert(manager->context_cnt == 0) - if the recursive hjoin_execute_internal
 *                inside partitioning triggers hjoin_try_parallel_probe again, a debug build
 *                crashes)
 *
 * Key points:
 *   - the build input is grown past the partitioning threshold so that SPLIT is triggered, and
 *     parallel(N) turns on partition parallelism
 *   - in that state the single-context parallel probe must not fire in addition
 *   - checked with both the text and the JSON trace
 *
 * Judged by the answer file:
 *   - count(*) 100000
 *   - SPLIT and a PARALLEL node are present and the HASHJOIN line carries "parallel workers",
 *     which is partition parallelism
 *   - yet there is no worker sub-line below PROBE, and that is the evidence of no re-entry
 *
 * Prerequisite: CTP runs SQL tests with test_mode=yes, so prm_tune_parameters() lowers
 *   parallel_hash_join_page_threshold from its default 256 pages to 0 (floored to 2 by
 *   compute_parallel_degree). Without it the probe lists here stay under 256 pages and the
 *   parallel-probe cases fall back to a serial probe.
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_big, t_med;

create table t_big (ckey int, cval int);
create table t_med (ckey int, cval int);

-- make the build side large enough to cross the partitioning threshold
insert into t_big
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, rownum from cte a, cte b limit 200000;

insert into t_med
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 1000) from cte a, cte b limit 100000;

update statistics on t_big, t_med with fullscan;

-- force partitioning
set system parameters 'max_hash_list_scan_size=256k';

set trace on;

evaluate 'Case 1: partition path - the parallel probe must not re-enter here';

select /*+ recompile use_hash ordered parallel(4) */
  count (*)
from t_med a, t_big b where a.ckey = b.ckey;
show trace;

evaluate 'Case 2: same query as JSON trace - partition path method string';

set trace on output json;

select /*+ recompile use_hash ordered parallel(4) */
  count (*)
from t_med a, t_big b where a.ckey = b.ckey;
show trace;

set trace off;
set system parameters 'max_hash_list_scan_size=default';

drop table t_big, t_med;
