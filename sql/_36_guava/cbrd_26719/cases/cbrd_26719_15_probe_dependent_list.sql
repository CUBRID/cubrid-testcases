/*
 * CBRD-26719 - sector distribution when the probe input is a dependent list chain
 *   covers: A/C (1) when the probe list_id spans several tfiles
 *
 * Key points:
 *   - qfile_collect_list_sector_info(), which collects the probe sectors, walks the whole chain
 *     by following dependent_list_id. A combined probe input such as a UNION ALL gives the
 *     QFILE_LIST_ID such a chain, and only then does tfiles[] hold several entries so that the
 *     right tfile has to be picked per sector
 *   - 03_probe_overflow_tuple looks similar but its chain is overflow pages inside one list file,
 *     so tfiles[] holds a single entry. The two files are a pair on the same mechanism
 *   - CBRD-25717's sector_dependent_list exercises the same function during the partition split
 *     stage. This file looks at the probe stage, so the build side has to stay small enough that
 *     no SPLIT occurs. A SPLIT would make this a duplicate of that case
 *   - ordered pins the derived table as the probe side
 *   - Cases 5 and 6 leave 20 percent of the probe keys without a partner for the NULL-fill path
 *
 * Judged by the answer file:
 *   - Cases 1 and 2: cnt 72000 / sval 72360000 (3-way UNION ALL)
 *   - Cases 3 and 4: cnt 120000 / sval 120600000 (5-way UNION ALL, a deeper chain)
 *   - Cases 5 and 6: total_rows 90000 / matched 72000 / null_filled 18000
 *   - Case 7: both EXCEPT directions 0
 *   - a worker sub-line below PROBE in Cases 1, 3 and 5 but not in 2, 4 and 6
 *   - a UNION tree feeding the hash join, BUILD method: memory, and no SPLIT
 *
 * Why SCAN-level parallel markers appear in the answer file:
 *   no_parallel_scan applies only to the outer SELECT, and each UNION ALL branch is rewritten as
 *   its own subplan that does not inherit the hint. Those markers are unrelated to this feature
 *   and cannot be suppressed from the outer hint. Whether the parallel probe ran is judged only
 *   from the line directly below PROBE. The branches are fully materialized before the hash join
 *   starts, so they never compete with the probe workers for the pool.
 *
 * Not judgeable from the answer file:
 *   - the length of the dependent_list_id chain or the number of tfiles[] entries
 *
 * Source: own addition (not in the JIRA attachment)
 */

drop table if exists t_dl_build, t_dl_pa, t_dl_pb, t_dl_pc;

-- small build side: keys 1..200 only, so no partitioning
create table t_dl_build (ckey int, cval int);

insert into t_dl_build
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, n * 10 from cte;

-- three probe fragments. cval is the join key and spans 1..250, so 201..250 find no partner
create table t_dl_pa (ckey int, cval int);
create table t_dl_pb (ckey int, cval int);
create table t_dl_pc (ckey int, cval int);

insert into t_dl_pa
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 250) + 1 from cte a, cte b limit 30000;

insert into t_dl_pb
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum + 30000, mod (rownum, 250) + 1 from cte a, cte b limit 30000;

insert into t_dl_pc
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum + 60000, mod (rownum, 250) + 1 from cte a, cte b limit 30000;

update statistics on t_dl_build, t_dl_pa, t_dl_pb, t_dl_pc with fullscan;

set system parameters 'max_hash_list_scan_size=8M'; -- default value, so no partitioning

set trace on;

evaluate 'Case 1: probe is a 3-way UNION ALL (dependent list chain) - parallel probe active';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from (select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb
      union all select ckey, cval from t_dl_pc) a,
     t_dl_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 2: same 3-way UNION ALL probe single-threaded - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from (select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb
      union all select ckey, cval from t_dl_pc) a,
     t_dl_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 3: deeper chain - 5-way UNION ALL probe - parallel probe active';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from (select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb
      union all select ckey, cval from t_dl_pc
      union all select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb) a,
     t_dl_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 4: same 5-way UNION ALL probe single-threaded - must match Case 3';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as cnt, sum (cast (b.cval as bigint)) as sval
from (select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb
      union all select ckey, cval from t_dl_pc
      union all select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb) a,
     t_dl_build b
where a.cval = b.ckey;

show trace;

evaluate 'Case 5: LEFT OUTER with a dependent-list probe - 20 percent NULL-filled';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled
from (select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb
      union all select ckey, cval from t_dl_pc) a
  left outer join t_dl_build b on a.cval = b.ckey;

show trace;

evaluate 'Case 6: same dependent-list LEFT OUTER single-threaded - must match Case 5';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.ckey) as matched,
  count (case when b.ckey is null then 1 end) as null_filled
from (select ckey, cval from t_dl_pa
      union all select ckey, cval from t_dl_pb
      union all select ckey, cval from t_dl_pc) a
  left outer join t_dl_build b on a.cval = b.ckey;

show trace;

set trace off;

evaluate 'Case 7: row set equality both ways over the dependent-list probe';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.cval as bcval
    from (select ckey, cval from t_dl_pa
          union all select ckey, cval from t_dl_pb
          union all select ckey, cval from t_dl_pc) a,
         t_dl_build b
    where a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.cval as bcval
    from (select ckey, cval from t_dl_pa
          union all select ckey, cval from t_dl_pb
          union all select ckey, cval from t_dl_pc) a,
         t_dl_build b
    where a.cval = b.ckey
  );

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.cval as bcval
    from (select ckey, cval from t_dl_pa
          union all select ckey, cval from t_dl_pb
          union all select ckey, cval from t_dl_pc) a,
         t_dl_build b
    where a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.cval as bcval
    from (select ckey, cval from t_dl_pa
          union all select ckey, cval from t_dl_pb
          union all select ckey, cval from t_dl_pc) a,
         t_dl_build b
    where a.cval = b.ckey
  );

set system parameters 'max_hash_list_scan_size=default';

drop table t_dl_build, t_dl_pa, t_dl_pb, t_dl_pc;
