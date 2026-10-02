/*
 * CBRD-26719 - falling back to a serial single probe when an entry condition fails, never to
 *   partitioning
 *   covers: C2
 *
 * Key points:
 *   - parallel(0), parallel(1) and NO_PARALLEL_HASH_JOIN all fail at entry condition (2).
 *     compute_parallel_degree() returns 0 as soon as the requested degree is below 2, and
 *     NO_PARALLEL_HASH_JOIN drives that degree to 0 in the first place, so all three hit the
 *     same gate
 *   - entry condition (3), a failed worker pool reservation, is not exercised here. That one
 *     belongs to cubrid-testcases-private-ex/shell/_40_guava/cbrd_26719
 *   - the build side is small, so partitioning does not meet its own trigger either
 *
 * Judged by the answer file:
 *   - all three queries return count(*) 100
 *   - no worker sub-line below PROBE in any of the three traces (serial fallback)
 *   - no SPLIT and no PARALLEL node. A SPLIT would mean the query leaked into the partition path
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_b, t_p;

create table t_b (ckey int);
create table t_p (ckey int);

insert into t_b
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
  select n from cte;

insert into t_p
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum from cte a, cte b limit 50000;

update statistics on t_b, t_p with fullscan;

set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: PARALLEL(1) - requested degree below 2, falls back to a serial probe';

select /*+ recompile use_hash ordered parallel(1)
           no_parallel_scan no_parallel_subquery */
  count (*)
from t_p a, t_b b where a.ckey = b.ckey;
show trace;

evaluate 'Case 2: PARALLEL(0) - explicitly disabled, serial probe';

select /*+ recompile use_hash ordered parallel(0) */
  count (*)
from t_p a, t_b b where a.ckey = b.ckey;
show trace;

evaluate 'Case 3: NO_PARALLEL_HASH_JOIN - serial probe, and no partitioning either';

select /*+ recompile use_hash ordered no_parallel_hash_join
           no_parallel_scan no_parallel_subquery */
  count (*)
from t_p a, t_b b where a.ckey = b.ckey;
show trace;

set trace off;

set system parameters 'max_hash_list_scan_size=default';

drop table t_b, t_p;
