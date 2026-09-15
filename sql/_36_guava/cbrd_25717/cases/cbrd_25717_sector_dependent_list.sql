/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 *                        (co-verifies CBRD-26666: sector-based split phase)
 * Scenario file: sector-based parallel split over base/dependent list files
 * Coverage: CBRD-26666 introduced sector-based page distribution in the parallel
 *           hash-join split phase. When a hash-join input is a UNION ALL (or otherwise
 *           combined) result, its QFILE_LIST_ID carries a dependent_list_id chain, so
 *           qfile_collect_list_sector_info() must walk base + all dependent lists and
 *           track the correct tfile per sector (m_current_tfile / tfiles[]).
 * How verified: parallel(N) results must be identical to the single-threaded
 *           (no_parallel_hash_join) baseline for inputs that produce dependent lists.
 *           Both runs emit SQL Trace. The discriminators are the PARALLEL node (wrapping
 *           BUILD/PROBE) and the "parallel workers" attribute on the HASHJOIN line - both
 *           present only in the parallel case. SPLIT is NOT a discriminator: it appears in
 *           both runs, because partitioning is orthogonal to parallelism. Tracing only the
 *           parallel case would make the pairing vacuous - a silently ignored
 *           no_parallel_hash_join would run both sides in parallel and the results would
 *           still match.
 * Note: SUM cast to BIGINT to avoid INT overflow; every result is a single aggregate row, and
 *       the multi-row inputs are keyed on a unique ckey, so no ORDER BY is needed for determinism.
 * Source: own addition (not in the JIRA attachment) - covers the CBRD-26666 sector-split path.
 */

-- test data
drop table if exists t_sda, t_sdb, t_sdc;

create table t_sda (ckey int, cval int);
create table t_sdb (ckey int, cval int);
create table t_sdc (ckey int, cval int);

insert into t_sda
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 7) from cte a, cte b limit 100000;

insert into t_sdb
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 5) from cte a, cte b limit 60000;

insert into t_sdc
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum + 60000, mod (rownum, 5) from cte a, cte b limit 40000;

update statistics on t_sda, t_sdb, t_sdc;

-- lower the threshold so a partition hash join (and sector-based parallel split) is triggered
set system parameters 'max_hash_list_scan_size=256k';

evaluate 'Case 1: PARALLEL hash join with UNION ALL inner (dependent list) - result';

set trace on;

select /*+ recompile use_hash parallel(8) */
  count (*) as cnt, sum (cast (a.ckey as bigint)) as skey, sum (b.cval) as sval
from t_sda a, (select ckey, cval from t_sdb union all select ckey, cval from t_sdc) b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 2: same join single-threaded (NO_PARALLEL_HASH_JOIN) - must match Case 1';

select /*+ recompile use_hash no_parallel_hash_join */
  count (*) as cnt, sum (cast (a.ckey as bigint)) as skey, sum (b.cval) as sval
from t_sda a, (select ckey, cval from t_sdb union all select ckey, cval from t_sdc) b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 3: deeper dependent-list chain (4-way UNION ALL) - parallel';

select /*+ recompile use_hash parallel(8) */
  count (*) as cnt, sum (b.cval) as sval
from t_sda a,
  (select ckey, cval from t_sdb union all select ckey, cval from t_sdc
   union all select ckey, cval from t_sdb union all select ckey, cval from t_sdc) b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 4: same 4-way UNION ALL join single-threaded - must match Case 3';

select /*+ recompile use_hash no_parallel_hash_join */
  count (*) as cnt, sum (b.cval) as sval
from t_sda a,
  (select ckey, cval from t_sdb union all select ckey, cval from t_sdc
   union all select ckey, cval from t_sdb union all select ckey, cval from t_sdc) b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 5: UNION ALL on BOTH sides (both inputs carry dependent lists) - parallel';

select /*+ recompile use_hash parallel(8) */
  count (*) as cnt
from (select ckey from t_sdb union all select ckey from t_sdc) a,
     (select ckey from t_sdb union all select ckey from t_sdc) b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 6: same both-sides join single-threaded - must match Case 5';

select /*+ recompile use_hash no_parallel_hash_join */
  count (*) as cnt
from (select ckey from t_sdb union all select ckey from t_sdc) a,
     (select ckey from t_sdb union all select ckey from t_sdc) b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 7: LEFT OUTER join, UNION ALL null-supplying side - parallel';

select /*+ recompile ordered use_hash parallel(8) */
  count (*) as cnt, count (b.ckey) as matched
from t_sda a
  left outer join (select ckey, cval from t_sdb union all select ckey, cval from t_sdc) b
  on a.ckey = b.ckey;

show trace;

evaluate 'Case 8: same LEFT OUTER join single-threaded - must match Case 7';

select /*+ recompile ordered use_hash no_parallel_hash_join */
  count (*) as cnt, count (b.ckey) as matched
from t_sda a
  left outer join (select ckey, cval from t_sdb union all select ckey, cval from t_sdc) b
  on a.ckey = b.ckey;

show trace;

set trace off;

-- clean up test data
set system parameters 'max_hash_list_scan_size=default';

drop table t_sda, t_sdb, t_sdc;
