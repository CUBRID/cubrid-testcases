/*
 * CBRD-26719 - OUTER join with one empty input, which takes the NULL-fill path and bypasses the
 *   parallel probe
 *   covers: C7 (HASHJOIN_STATUS_FILL_NULL_VALUES branches into hjoin_outer_fill_null_values)
 *
 * Key points:
 *   - Case 1 empties the null-supplying side of a LEFT OUTER, so every outer row is NULL-filled
 *   - Case 2 empties the preserved side of a RIGHT OUTER, so the result is 0 rows. In the April
 *     attachment this slot repeated Case 1, leaving that shape uncovered
 *   - entering the parallel probe here would hand workers pointless work on an empty build side,
 *     or drop rows
 *
 * Judged by the answer file:
 *   - Case 1 outer_rows 50000 / matched 0, Case 2 outer_rows 0 / matched 0, Case 3 (serial)
 *     matches Case 1
 *   - BUILD reports method: skip, meaning the build stage is skipped
 *   - no worker sub-line below PROBE, no SPLIT and no PARALLEL node
 *
 * Not recorded in the answer file:
 *   - HASHJOIN_STATUS_FILL_NULL_VALUES is an internal state name and never printed. The verdict
 *     rests on method: skip, the absent worker sub-line and the result values
 *   - the "parallel workers" markers on SCAN and aggregate nodes are unrelated to this feature
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_empty, t_full;

create table t_empty (ckey int);
create table t_full  (ckey int);

-- t_empty is left with 0 rows
insert into t_full
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum from cte a, cte b limit 50000;

update statistics on t_empty, t_full with fullscan;

set trace on;

evaluate 'Case 1: LEFT OUTER with an empty build side - every row NULL-filled, parallel probe bypassed';

select /*+ recompile use_hash ordered parallel(4) */
  count (*) as outer_rows,
  count (b.ckey) as matched
from t_full a left outer join t_empty b on a.ckey = b.ckey;
show trace;

evaluate 'Case 2: RIGHT OUTER preserving the EMPTY side - result must be 0 rows';

select /*+ recompile use_hash ordered parallel(4) */
  count (*) as outer_rows,
  count (b.ckey) as matched
from t_full a right outer join t_empty b on a.ckey = b.ckey;
show trace;

evaluate 'Case 3: same LEFT OUTER single-threaded - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) */
  count (*) as outer_rows,
  count (b.ckey) as matched
from t_full a left outer join t_empty b on a.ckey = b.ckey;

set trace off;

drop table t_empty, t_full;
