/*
 * CBRD-26719 - probe-side data distribution: NULL keys, duplicate keys and skew
 *   covers: A/C (1), the parallel result equals the single-thread result whatever the shape of
 *           the probe data
 *
 * Key points:
 *   - the feature hands out the probe input sector by sector, yet the probe data in the attached
 *     cases is spread evenly. A bug in the distribution logic does not show up on an even spread
 *   - Cases 1 and 2: 10 percent of the probe keys are NULL and must never match
 *   - Cases 3 and 4: several build rows per key (N:M), so workers emit more rows than they read
 *   - Cases 5 and 6: 80 percent of the probe rows carry one key. The sector split stays even but
 *     the amount of matching does not
 *   - every case keeps the build side small, so the single-context path holds
 *
 * Judged by the answer file:
 *   - Cases 1 and 2: cnt 270000 / sval 81000000
 *   - Cases 3 and 4: cnt 300000 / sval 90150000
 *   - Cases 5 and 6: cnt 300000 / sval 114210000
 *   - a worker sub-line below PROBE in Cases 1, 3 and 5 but not in 2, 4 and 6, and no SPLIT
 *
 * Not judgeable from the answer file:
 *   - the amount emitted per worker. How the matching volume splits under skew is the point of
 *     this case, but it cannot be read from the answer file. The totals are compared instead
 *
 * Source: own addition (not in the JIRA attachment)
 */

drop table if exists t_pd_build, t_pd_null, t_pd_dup, t_pd_skew;

-- build: keys 1..200, three rows per key for the N:M cases
create table t_pd_build (ckey int, cval int);

insert into t_pd_build
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 600)
  select mod (n, 200) + 1, n from cte;

-- probe: 10 percent of the keys are NULL
create table t_pd_null (ckey int, cval int);

insert into t_pd_null
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum,
         case when mod (rownum, 10) = 0 then null else mod (rownum, 200) + 1 end
  from cte a, cte b limit 100000;

-- probe: every key exists in build, for the N:M check
create table t_pd_dup (ckey int, cval int);

insert into t_pd_dup
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 200) + 1 from cte a, cte b limit 100000;

-- probe: skewed, 80 percent of the rows carry the single key 1
create table t_pd_skew (ckey int, cval int);

insert into t_pd_skew
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum,
         case when mod (rownum, 10) < 8 then 1 else mod (rownum, 200) + 1 end
  from cte a, cte b limit 100000;

update statistics on t_pd_build, t_pd_null, t_pd_dup, t_pd_skew with fullscan;

set system parameters 'max_hash_list_scan_size=8M'; -- default value, so no partitioning

set trace on;

evaluate 'Case 1: probe side has 10% NULL keys - parallel probe, NULL must never match';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_pd_null a, t_pd_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 2: same NULL-key probe single-threaded - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_pd_null a, t_pd_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 3: N:M - each probe row matches 3 build rows, workers emit more than they read';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_pd_dup a, t_pd_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 4: same N:M join single-threaded - must match Case 3';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_pd_dup a, t_pd_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 5: skewed probe - 80% of rows carry one key, match volume is uneven across workers';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_pd_skew a, t_pd_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 6: same skewed probe single-threaded - must match Case 5';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from t_pd_skew a, t_pd_build b
where a.cval = b.ckey;

show trace;

set trace off;

set system parameters 'max_hash_list_scan_size=default';

drop table t_pd_build, t_pd_null, t_pd_dup, t_pd_skew;
