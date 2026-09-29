/*
 * CBRD-26719 - single-context parallel probe with LEFT OUTER and a during_join_pred
 *   covers: C6 (spawn_manager TLS clone that isolates the residual predicate)
 *
 * Key points:
 *   - matches for which the during predicate is false become NULL-filled rows, so that count has
 *     to agree exactly with the single-threaded run. A cross-worker race in the residual
 *     evaluation would make the counts diverge
 *   - the isolation itself never appears in the trace, so the verdict rests on the counts
 *
 * Judged by the answer file:
 *   - total 50000, null_filled 33334, matched 16666, identical in Case 1 (parallel) and
 *     Case 2 (serial), and both EXCEPT directions 0
 *   - a worker sub-line below PROBE in Case 1, and no SPLIT
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_outer, t_inner;

create table t_outer (id int, ckey int);
create table t_inner (id int, ckey int);

insert into t_inner
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, n from cte;

insert into t_outer
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 200) + 1 from cte a, cte b limit 50000;

update statistics on t_outer, t_inner with fullscan;

set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: LEFT OUTER + during_join_pred, parallel probe - residual evaluated per worker';

select /*+ recompile use_hash ordered parallel(4)
           no_parallel_scan no_parallel_subquery */
  count (*) as total,
  count (case when b.id is null then 1 end) as null_filled,
  count (case when b.id is not null then 1 end) as matched
from t_outer a left outer join t_inner b
  on a.ckey = b.id and mod (a.id, 3) = 0;
show trace;

evaluate 'Case 2: same join single-threaded - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) */
  count (*) as total,
  count (case when b.id is null then 1 end) as null_filled,
  count (case when b.id is not null then 1 end) as matched
from t_outer a left outer join t_inner b
  on a.ckey = b.id and mod (a.id, 3) = 0;

set trace off;

evaluate 'Case 3: trace is off from here - row set equality both ways, each result must be 0';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.id as a_id, b.id as b_id
    from t_outer a left outer join t_inner b
      on a.ckey = b.id and mod (a.id, 3) = 0
    except
    select /*+ use_hash ordered parallel(0) */ a.id as a_id, b.id as b_id
    from t_outer a left outer join t_inner b
      on a.ckey = b.id and mod (a.id, 3) = 0
  );
-- expected: 0

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.id as a_id, b.id as b_id
    from t_outer a left outer join t_inner b
      on a.ckey = b.id and mod (a.id, 3) = 0
    except
    select /*+ use_hash ordered parallel(4) */ a.id as a_id, b.id as b_id
    from t_outer a left outer join t_inner b
      on a.ckey = b.id and mod (a.id, 3) = 0
  );
-- expected: 0

set system parameters 'max_hash_list_scan_size=default';

drop table t_outer, t_inner;
