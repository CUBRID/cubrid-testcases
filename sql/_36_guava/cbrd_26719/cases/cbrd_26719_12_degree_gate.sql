/*
 * CBRD-26719 - the parallel probe entry gate decided by the probe input size
 *   covers: entry condition (2), degree computed from probe pages and requested parallelism >= 2
 *
 * Key points:
 *   - 06_fallback_serial only makes the gate fail through hints that lower the requested
 *     parallelism to 0 or 1. The degree also depends on the probe page count, and that axis was
 *     left unverified
 *   - Cases 1 and 2 use a tiny probe. Even with PARALLEL(4) the degree stays below 2 and the
 *     query falls back to a single thread
 *   - Cases 3 and 4 use the same schema with a much larger probe, so the degree reaches 2 or more
 *   - the only difference between the two pairs is the probe size, so the presence or absence of
 *     the worker sub-line is exactly what entry condition (2) does
 *
 * Judged by the answer file:
 *   - Cases 1 and 2 return count(*) 200, Cases 3 and 4 return count(*) 100000
 *   - only Case 3 carries a worker sub-line below PROBE
 *   - no SPLIT (a small probe leaking into partitioning would be a regression)
 *
 * Not judgeable from the answer file:
 *   - the actual degree. Only the presence of the worker sub-line is judged, never the value
 *
 * Source: own addition (not in the JIRA attachment)
 */

drop table if exists t_dg_build, t_dg_small, t_dg_big;

create table t_dg_build (ckey int, cval int);
create table t_dg_small (ckey int, cval int);
create table t_dg_big   (ckey int, cval int);

-- the build side stays equally small in both pairs, keeping the single-context path
insert into t_dg_build
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, n * 10 from cte;

-- small probe: too few pages, so the computed degree stays below 2
insert into t_dg_small
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, mod (n, 200) + 1 from cte;

-- large probe: same schema, only the row count grows
insert into t_dg_big
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 200) + 1 from cte a, cte b limit 100000;

update statistics on t_dg_build, t_dg_small, t_dg_big with fullscan;

set system parameters 'max_hash_list_scan_size=8M'; -- default value, so no partitioning

set trace on;

evaluate 'Case 1: small probe + PARALLEL(4) -> degree < 2, falls back to single-thread probe';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*)
from t_dg_small a, t_dg_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 2: same small-probe join with PARALLEL(0) - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*)
from t_dg_small a, t_dg_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 3: large probe + PARALLEL(4) -> degree >= 2, parallel probe engages';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*)
from t_dg_big a, t_dg_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 4: same large-probe join with PARALLEL(0) - must match Case 3';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*)
from t_dg_big a, t_dg_build b
where a.cval = b.ckey;

show trace;

set trace off;

set system parameters 'max_hash_list_scan_size=default';

drop table t_dg_build, t_dg_small, t_dg_big;
