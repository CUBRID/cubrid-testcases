/**
 * This test case verifies CBRD-25717: Support PARALLEL HASH JOIN
 *                        (co-verifies CBRD-26666: overflow tuples on the sector-based split path)
 * Scenario file: overflow records inside a dependent list (UNION ALL) under parallel split
 * Coverage: CBRD-26666 made overflow-tuple handling compatible with the sector-based scan -
 *           continuation pages share the sector bitmap with regular data pages, and
 *           m_current_tfile must track which tfile a page came from so the overflow chain is
 *           fetched from the right file while the scan walks base + dependent list files.
 *           overflow_record covers overflow over a base list, sector_dependent_list covers a
 *           dependent-list chain without overflow; this case is their intersection.
 * How verified: every parallel case is paired with a single-threaded (no_parallel_hash_join)
 *           run of the same query - the results must be identical. Both runs emit SQL Trace. The
 *           discriminators are the PARALLEL node (wrapping BUILD/PROBE) and the "parallel workers"
 *           attribute on the HASHJOIN line - both present only in the parallel case. SPLIT is NOT
 *           a discriminator: it appears in both runs, because partitioning is orthogonal to
 *           parallelism. Tracing only the parallel case would make the pairing vacuous - a
 *           silently ignored no_parallel_hash_join would run both sides in parallel and the
 *           results would still match.
 * Note: bit(32000) x 5 (~20KB) exceeds one page, so each tuple spans continuation pages, and the
 *       big columns are projected through a NO_MERGE derived table so they are really carried in
 *       the list file. The row count (10000 per side) is what pushes the build past
 *       max_hash_list_scan_size into the partition path - the hybrid estimate scales with row
 *       count, not tuple size. The CTE stays at depth 2000 (cross join) to avoid
 *       ER_CTE_MAX_RECURSION_REACHED.
 * Source: own addition (not in the JIRA attachment) - targets the CBRD-26666 overflow x dependent-list path.
 */

--
-- test data
--

drop table if exists t_ovp, t_ovda, t_ovdb;

-- left-side probe keys 1..12000 ; the overflow tables only cover 1..10000
-- (so the LEFT OUTER case keeps 2000 unmatched rows)
create table t_ovp (ckey int);

create table t_ovda (
    ckey int,
    da bit(32000), db bit(32000), dc bit(32000), dd bit(32000), de bit(32000)
  );

create table t_ovdb (
    ckey int,
    da bit(32000), db bit(32000), dc bit(32000), dd bit(32000), de bit(32000)
  );

insert into t_ovp
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum from cte a, cte b limit 12000;

insert into t_ovda
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum, B'1', B'1', B'1', B'1', B'1' from cte a, cte b limit 5000;

insert into t_ovdb
  with recursive cte(n) as (
    select 1
    union all
    select n + 1 from cte where n < 2000
  )
  select rownum + 5000, B'1', B'1', B'1', B'1', B'1' from cte a, cte b limit 5000;

update statistics on t_ovp, t_ovda, t_ovdb;

-- lower the threshold so a partition hash join (and sector-based parallel split) is triggered
set system parameters 'max_hash_list_scan_size=256k';


evaluate 'Case 1: overflow dependent lists (UNION ALL) on BOTH sides - parallel';

set trace on;

select /*+ recompile no_parallel_scan no_parallel_subquery */
  count (*)
from (
    select /*+ recompile
               use_hash
               no_merge
               no_parallel_scan
               no_parallel_subquery */
      a.ckey as a_ckey, a.da as a_da, a.db as a_db, a.dc as a_dc, a.dd as a_dd, a.de as a_de,
      b.ckey as b_ckey, b.da as b_da, b.db as b_db, b.dc as b_dc, b.dd as b_dd, b.de as b_de
    from
      (select ckey, da, db, dc, dd, de from t_ovda
       union all
       select ckey, da, db, dc, dd, de from t_ovdb) a,
      (select ckey, da, db, dc, dd, de from t_ovda
       union all
       select ckey, da, db, dc, dd, de from t_ovdb) b
    where a.ckey = b.ckey
  );

show trace;

evaluate 'Case 2: same both-sides join single-threaded (NO_PARALLEL_HASH_JOIN) - must match Case 1';

select /*+ recompile no_parallel_scan no_parallel_subquery */
  count (*)
from (
    select /*+ recompile
               use_hash
               no_merge
               no_parallel_scan
               no_parallel_subquery
               no_parallel_hash_join */
      a.ckey as a_ckey, a.da as a_da, a.db as a_db, a.dc as a_dc, a.dd as a_dd, a.de as a_de,
      b.ckey as b_ckey, b.da as b_da, b.db as b_db, b.dc as b_dc, b.dd as b_dd, b.de as b_de
    from
      (select ckey, da, db, dc, dd, de from t_ovda
       union all
       select ckey, da, db, dc, dd, de from t_ovdb) a,
      (select ckey, da, db, dc, dd, de from t_ovda
       union all
       select ckey, da, db, dc, dd, de from t_ovdb) b
    where a.ckey = b.ckey
  );

show trace;


evaluate 'Case 3: LEFT OUTER, null-supplying side is an overflow dependent list (2000 unmatched rows kept) - parallel';

select /*+ recompile no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b_ckey) as matched
from (
    select /*+ recompile
               ordered
               use_hash
               no_merge
               no_parallel_scan
               no_parallel_subquery */
      a.ckey as a_ckey,
      b.ckey as b_ckey, b.da as b_da, b.db as b_db, b.dc as b_dc, b.dd as b_dd, b.de as b_de
    from t_ovp a
      left outer join
      (select ckey, da, db, dc, dd, de from t_ovda
       union all
       select ckey, da, db, dc, dd, de from t_ovdb) b
      on a.ckey = b.ckey
  );

show trace;

evaluate 'Case 4: same LEFT OUTER join single-threaded - must match Case 3';

select /*+ recompile no_parallel_scan no_parallel_subquery */
  count (*) as cnt, count (b_ckey) as matched
from (
    select /*+ recompile
               ordered
               use_hash
               no_merge
               no_parallel_scan
               no_parallel_subquery
               no_parallel_hash_join */
      a.ckey as a_ckey,
      b.ckey as b_ckey, b.da as b_da, b.db as b_db, b.dc as b_dc, b.dd as b_dd, b.de as b_de
    from t_ovp a
      left outer join
      (select ckey, da, db, dc, dd, de from t_ovda
       union all
       select ckey, da, db, dc, dd, de from t_ovdb) b
      on a.ckey = b.ckey
  );

show trace;


set trace off;

--
-- clean up test data
--

drop table t_ovp, t_ovda, t_ovdb;

-- restore default so it does not leak into later cases
set system parameters 'max_hash_list_scan_size=default';
