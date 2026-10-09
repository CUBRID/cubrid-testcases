/*
 * CBRD-26719 - OUTER join where the probe-side join key is NULL
 *   covers: the NULL-key branch in hjoin_fetch_key() - when a probe key is NULL the worker must
 *           NULL-fill the row directly, without probing the hash table
 *
 * Key points:
 *   - the probe has 10 percent NULL keys; the rest all exist in build (three rows per key)
 *   - a NULL key never matches, so in an OUTER join those rows must be NULL-filled, not dropped
 *   - 13_probe_distribution also carries 10 percent NULL keys but joins INNER, so there the NULL
 *     rows are dropped. The attachment's OUTER cases (02, 04, 05, 11, 14, 15) carry no NULL probe
 *     key, so this NULL-fill branch was uncovered
 *   - both LEFT OUTER and RIGHT OUTER are exercised, parallel against serial
 *   - build stays small, so the single-context path holds (no SPLIT)
 *
 * Judged by the answer file:
 *   - all four queries: total_rows 280000, matched 270000, null_filled 10000, sval 81000000
 *   - Cases 1 and 3 (parallel) carry a worker sub-line below PROBE; Cases 2 and 4 (serial) do not
 *   - Case 5 EXCEPT both directions 0
 *   - no SPLIT
 *
 * Prerequisite: CTP runs SQL tests with test_mode=yes, so prm_tune_parameters() lowers
 *   parallel_hash_join_page_threshold from its default 256 pages to 0 (floored to 2 by
 *   compute_parallel_degree). Without it the probe lists here stay under 256 pages and the
 *   parallel-probe cases fall back to a serial probe.
 *
 * Source: own addition (proposed in the PR #3594 review)
 */

drop table if exists t_nk_build, t_nk_probe;

-- build: keys 1..200, three rows per key
create table t_nk_build (ckey int, cval int);

insert into t_nk_build
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 600)
  select mod (n, 200) + 1, n from cte;

-- probe: 10 percent of the keys are NULL, the rest all exist in build
create table t_nk_probe (ckey int, cval int);

insert into t_nk_probe
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum,
         case when mod (rownum, 10) = 0 then null else mod (rownum, 200) + 1 end
  from cte a, cte b limit 100000;

update statistics on t_nk_build, t_nk_probe with fullscan;

-- default value, so no partitioning
set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: LEFT OUTER with 10 percent NULL probe keys - NULL rows must be NULL-filled, not dropped';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled,
  sum (cast (b.cval as bigint)) as sval
from t_nk_probe a left outer join t_nk_build b on a.cval = b.ckey;

show trace;

evaluate 'Case 2: same NULL-key LEFT OUTER single-threaded - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled,
  sum (cast (b.cval as bigint)) as sval
from t_nk_probe a left outer join t_nk_build b on a.cval = b.ckey;

show trace;

evaluate 'Case 3: RIGHT OUTER with 10 percent NULL probe keys - parallel probe';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled,
  sum (cast (b.cval as bigint)) as sval
from t_nk_build b right outer join t_nk_probe a on a.cval = b.ckey;

show trace;

evaluate 'Case 4: same NULL-key RIGHT OUTER single-threaded - must match Case 3';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled,
  sum (cast (b.cval as bigint)) as sval
from t_nk_build b right outer join t_nk_probe a on a.cval = b.ckey;

show trace;

set trace off;

evaluate 'Case 5: row set equality both ways over the NULL-key LEFT OUTER';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_nk_probe a left outer join t_nk_build b on a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_nk_probe a left outer join t_nk_build b on a.cval = b.ckey
  );

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_nk_probe a left outer join t_nk_build b on a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_nk_probe a left outer join t_nk_build b on a.cval = b.ckey
  );

set system parameters 'max_hash_list_scan_size=default';

drop table t_nk_build, t_nk_probe;
