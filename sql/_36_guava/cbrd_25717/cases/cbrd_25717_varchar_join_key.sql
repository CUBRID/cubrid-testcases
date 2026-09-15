/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 * Scenario file: VARCHAR join keys under the parallel partition hash join
 * Coverage: the whole suite joins on INT columns, yet the performance scenario in the CBRD-25717
 *           issue description itself builds "create table t1 (ckey varchar)" and joins on
 *           md5(rownum). A string key differs in two ways that reach the split path: hashing and
 *           equality go through collation rather than a machine word, and the tuples are
 *           variable-length, so page occupancy - and therefore the sector/page distribution the
 *           CBRD-26666 split phase computes - is no longer uniform.
 * How verified: every parallel case is paired with a single-threaded (no_parallel_hash_join) run
 *           of the same query - the results must be identical. Both runs emit SQL Trace; the
 *           PARALLEL node and the HASHJOIN "parallel workers" attribute appear only in the
 *           parallel case.
 * Note: md5() yields a fixed 32-char hex string, so Case 5/6 add a genuinely variable-length key
 *       (md5 repeated 1..3 times) to make page occupancy uneven rather than merely non-integer.
 *       Keys stay unique per row, so the joins are 1:1 and the counts are exact.
 * Source: own addition (not in the JIRA attachment) - matches the issue's own varchar workload.
 */

--
-- test data
--

drop table if exists t_vca, t_vcb, t_vva, t_vvb;

-- fixed-width string key (md5)
create table t_vca (ckey varchar(64), cval int);
create table t_vcb (ckey varchar(64), cval int);

insert into t_vca
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select md5 (rownum), mod (rownum, 7) from cte a, cte b limit 100000;

insert into t_vcb
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select md5 (rownum), mod (rownum, 5) from cte a, cte b limit 100000;

-- variable-width string key (md5 repeated 1..3 times -> 32 / 64 / 96 chars)
create table t_vva (ckey varchar(128), cval int);
create table t_vvb (ckey varchar(128), cval int);

insert into t_vva
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select repeat (md5 (rownum), mod (rownum, 3) + 1), mod (rownum, 7) from cte a, cte b limit 50000;

insert into t_vvb
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select repeat (md5 (rownum), mod (rownum, 3) + 1), mod (rownum, 5) from cte a, cte b limit 50000;

update statistics on t_vca, t_vcb, t_vva, t_vvb;

-- lower the threshold so a partition hash join (and sector-based parallel split) is triggered
set system parameters 'max_hash_list_scan_size=256k';

set trace on;


evaluate 'Case 1: INNER join on a fixed-width VARCHAR (md5) key - parallel';

select /*+ recompile use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (b.cval) as sval
from t_vca a, t_vcb b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 2: same VARCHAR join single-threaded (NO_PARALLEL_HASH_JOIN) - must match Case 1';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (b.cval) as sval
from t_vca a, t_vcb b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 3: LEFT OUTER on a VARCHAR key - parallel';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.ckey) as matched
from t_vca a left outer join t_vcb b on a.ckey = b.ckey;

show trace;

evaluate 'Case 4: same VARCHAR LEFT OUTER join single-threaded - must match Case 3';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.ckey) as matched
from t_vca a left outer join t_vcb b on a.ckey = b.ckey;

show trace;

evaluate 'Case 5: variable-width VARCHAR key (uneven page occupancy) - parallel';

select /*+ recompile use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (b.cval) as sval
from t_vva a, t_vvb b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 6: same variable-width VARCHAR join single-threaded - must match Case 5';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (b.cval) as sval
from t_vva a, t_vvb b
where a.ckey = b.ckey;

show trace;

set trace off;

--
-- clean up test data
--

drop table t_vca, t_vcb, t_vva, t_vvb;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
