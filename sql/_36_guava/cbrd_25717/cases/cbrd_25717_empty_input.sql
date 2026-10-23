/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 *                        (co-verifies CBRD-26666: sector-based split phase)
 * Scenario file: empty and non-matching inputs to the partition hash join
 * Coverage: boundary guard. The rest of the suite always joins two populated inputs that produce
 *           matches, so three shapes were never exercised: an empty BUILD side, an empty PROBE
 *           side, and two populated sides whose key ranges do not overlap at all (every row lands
 *           in a partition that finds no partner). These are the shapes where a split phase that
 *           mishandles a zero-page list file, a zero-sector input or an all-miss partition would
 *           crash or return a wrong count rather than 0.
 * How verified: every parallel case is paired with a single-threaded (no_parallel_hash_join) run
 *           of the same query - the results must be identical and must be 0.
 * Note: Cases 1-4 have one empty side, so there is nothing to partition and the trace shows no
 *       SPLIT - that is expected and is not what these cases assert. They are a crash/boundary
 *       guard. Cases 5 and 6 are the ones that genuinely exercise the partitioned path: both
 *       inputs are large enough to be split, they just never match, so every partition is
 *       processed and produces nothing.
 * Source: own addition (not in the JIRA attachment) - boundary coverage for the split phase.
 */

--
-- test data
--

drop table if exists t_ei_empty, t_ei_full, t_ei_lo, t_ei_hi;

create table t_ei_empty (ckey int, cval int);
create table t_ei_full (ckey int, cval int);

-- disjoint key ranges: t_ei_lo holds 1..100000, t_ei_hi holds 200001..300000
create table t_ei_lo (ckey int, cval int);
create table t_ei_hi (ckey int, cval int);

insert into t_ei_full
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 7) from cte a, cte b limit 100000;

insert into t_ei_lo
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 7) from cte a, cte b limit 100000;

insert into t_ei_hi
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum + 200000, mod (rownum, 5) from cte a, cte b limit 100000;

update statistics on t_ei_empty, t_ei_full, t_ei_lo, t_ei_hi;

-- lower the threshold so a partition hash join (and sector-based parallel split) is triggered
set system parameters 'max_hash_list_scan_size=256k';

set trace on;


evaluate 'Case 1: empty BUILD side (inner input has no rows) - parallel, expect 0';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from t_ei_full a, t_ei_empty b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 2: same empty-BUILD join single-threaded - must match Case 1';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from t_ei_full a, t_ei_empty b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 3: empty PROBE side (outer input has no rows) - parallel, expect 0';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from t_ei_empty a, t_ei_full b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 4: same empty-PROBE join single-threaded - must match Case 3';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from t_ei_empty a, t_ei_full b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 5: both sides populated but key ranges disjoint - parallel, every partition misses';

select /*+ recompile use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from t_ei_lo a, t_ei_hi b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 6: same disjoint-range join single-threaded - must match Case 5';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from t_ei_lo a, t_ei_hi b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 7: LEFT OUTER over an empty null-supplying side - all left rows survive';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.ckey) as matched
from t_ei_full a left outer join t_ei_empty b on a.ckey = b.ckey;

show trace;

evaluate 'Case 8: same LEFT OUTER join single-threaded - must match Case 7';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.ckey) as matched
from t_ei_full a left outer join t_ei_empty b on a.ckey = b.ckey;

show trace;

set trace off;

--
-- clean up test data
--

drop table t_ei_empty, t_ei_full, t_ei_lo, t_ei_hi;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
