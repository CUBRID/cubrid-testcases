/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 *                        (co-verifies CBRD-26666: NULL keys on the sector-based split path)
 * Scenario file: NULL join keys under the parallel partition hash join
 * Coverage: CBRD-26666 A/C (6) calls out "outer join + overflow, including the NULL-key last
 *           partition path". A NULL key never compares equal to anything - not even to another
 *           NULL - so it must be routed to the dedicated last partition and must never produce a
 *           match. The suite had no NULL join key anywhere before this file, so that partition
 *           was never exercised.
 * How verified: every parallel case is paired with a single-threaded (no_parallel_hash_join) run
 *           of the same query - the results must be identical. Both runs emit SQL Trace; the
 *           PARALLEL node and the HASHJOIN "parallel workers" attribute appear only in the
 *           parallel case (SPLIT appears in both - partitioning is orthogonal to parallelism).
 * Note: 10% of the keys on BOTH sides are NULL. This ratio is what makes the check sharp - if a
 *       regression ever let NULL match NULL, the INNER count would jump by 10000 x 10000 rather
 *       than drift, so the failure is unmissable. Expected: INNER 90000 matches, LEFT OUTER
 *       100000 rows of which 90000 matched and 10000 NULL-extended.
 * Note: Cases 5 and 6 project the bit(32000) columns through a NO_MERGE derived table on purpose.
 *       Selecting only count(*) and the join key lets the optimizer prune da..de, leaving nothing
 *       but a small int in the hash-join list tuples - measured on this build, the split phase then
 *       reads 46 pages instead of 29623, so the overflow continuation-page path is never touched
 *       and Cases 5/6 would pass even if that handling were broken. Forcing the wide columns into
 *       the list file is what makes the NULL-key partition and the overflow path run together.
 * Source: own addition (not in the JIRA attachment) - targets the CBRD-26666 NULL-key partition.
 */

--
-- test data
--

drop table if exists t_nka, t_nkb, t_nkoa, t_nkob;

-- plain int keys, every 10th key NULL
create table t_nka (ckey int, cval int);
create table t_nkb (ckey int, cval int);

insert into t_nka
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select case when mod (rownum, 10) = 0 then null else rownum end, mod (rownum, 7)
  from cte a, cte b limit 100000;

insert into t_nkb
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select case when mod (rownum, 10) = 0 then null else rownum end, mod (rownum, 5)
  from cte a, cte b limit 100000;

-- same NULL pattern, but the tuples are overflow records (A/C 6 pairs NULL keys with overflow)
create table t_nkoa (ckey int, da bit(32000), db bit(32000), dc bit(32000), dd bit(32000), de bit(32000));
create table t_nkob (ckey int, da bit(32000), db bit(32000), dc bit(32000), dd bit(32000), de bit(32000));

insert into t_nkoa
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select case when mod (rownum, 10) = 0 then null else rownum end,
         B'1', B'1', B'1', B'1', B'1'
  from cte a, cte b limit 10000;

insert into t_nkob
  with recursive cte(n) as (select 1 union all select n + 1 from cte where n < 2000)
  select case when mod (rownum, 10) = 0 then null else rownum end,
         B'1', B'1', B'1', B'1', B'1'
  from cte a, cte b limit 10000;

update statistics on t_nka, t_nkb, t_nkoa, t_nkob;

-- lower the threshold so a partition hash join (and sector-based parallel split) is triggered
set system parameters 'max_hash_list_scan_size=256k';

set trace on;


evaluate 'Case 1: INNER join, 10% NULL keys on both sides - parallel (NULL must never match)';

select /*+ recompile use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.ckey as bigint)) as skey
from t_nka a, t_nkb b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 2: same INNER join single-threaded (NO_PARALLEL_HASH_JOIN) - must match Case 1';

select /*+ recompile use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (a.ckey as bigint)) as skey
from t_nka a, t_nkb b
where a.ckey = b.ckey;

show trace;

evaluate 'Case 3: LEFT OUTER, NULL-key left rows must survive NULL-extended - parallel';

select /*+ recompile ordered use_hash parallel(8) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.ckey) as matched
from t_nka a left outer join t_nkb b on a.ckey = b.ckey;

show trace;

evaluate 'Case 4: same LEFT OUTER join single-threaded - must match Case 3';

select /*+ recompile ordered use_hash no_parallel_hash_join no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b.ckey) as matched
from t_nka a left outer join t_nkb b on a.ckey = b.ckey;

show trace;

evaluate 'Case 5: NULL keys carried by overflow records (A/C 6 combination) - parallel';

select /*+ recompile no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from (
    select /*+ recompile
               use_hash
               no_merge
               parallel(8)
               no_parallel_scan
               no_parallel_subquery */
      a.ckey as a_ckey, a.da as a_da, a.db as a_db, a.dc as a_dc, a.dd as a_dd, a.de as a_de,
      b.ckey as b_ckey, b.da as b_da, b.db as b_db, b.dc as b_dc, b.dd as b_dd, b.de as b_de
    from t_nkoa a, t_nkob b
    where a.ckey = b.ckey
  );

show trace;

evaluate 'Case 6: same overflow NULL-key join single-threaded - must match Case 5';

select /*+ recompile no_parallel_scan no_parallel_subquery */
  count (*) as cnt
from (
    select /*+ recompile
               use_hash
               no_merge
               no_parallel_hash_join
               no_parallel_scan
               no_parallel_subquery */
      a.ckey as a_ckey, a.da as a_da, a.db as a_db, a.dc as a_dc, a.dd as a_dd, a.de as a_de,
      b.ckey as b_ckey, b.da as b_da, b.db as b_db, b.dc as b_dc, b.dd as b_dd, b.de as b_de
    from t_nkoa a, t_nkob b
    where a.ckey = b.ckey
  );

show trace;

set trace off;

--
-- clean up test data
--

drop table t_nka, t_nkb, t_nkoa, t_nkob;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
