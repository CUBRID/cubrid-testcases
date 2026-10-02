/*
 * CBRD-26719 - single-context parallel probe baseline (LEFT OUTER, no during predicate)
 *   covers: C1, C6 (NULL-fill in a parallel probe outer join)
 *
 * Key points:
 *   - a plain OUTER baseline with no residual predicate (that case is 04_outer_during_pred)
 *   - some probe fk values are deliberately absent from the build side so that NULL-filled rows
 *     really occur. If everything matched, the NULL-fill path would never run
 *
 * Judged by the answer file:
 *   - total_rows 80000, matched 53334, null_filled 26666, both EXCEPT directions 0
 *   - a worker sub-line on the line directly below PROBE
 *   - no SPLIT
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_b, t_p;

create table t_b (id int, val int);
create table t_p (id int, fk int);

insert into t_b
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, n * 7 from cte;

-- some fk values are absent from t_b, so NULL-filled rows are produced
insert into t_p
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum,
         case when mod (rownum, 3) = 0 then 99999 else mod (rownum, 200) + 1 end
  from cte a, cte b limit 80000;

update statistics on t_b, t_p with fullscan;

set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: LEFT OUTER, parallel probe active - NULL-fill spread across workers';

select /*+ recompile use_hash ordered parallel(4)
           no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.id) as matched,
  count (case when b.id is null then 1 end) as null_filled
from t_p a left outer join t_b b on a.fk = b.id;
show trace;

set trace off;

evaluate 'Case 2: trace is off from here - row set equality both ways, each result must be 0';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */
      a.id as a_id, a.fk as a_fk, b.id as b_id, b.val as b_val
    from t_p a left outer join t_b b on a.fk = b.id
    except
    select /*+ use_hash ordered parallel(0) */
      a.id as a_id, a.fk as a_fk, b.id as b_id, b.val as b_val
    from t_p a left outer join t_b b on a.fk = b.id
  );
-- expected: 0

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */
      a.id as a_id, a.fk as a_fk, b.id as b_id, b.val as b_val
    from t_p a left outer join t_b b on a.fk = b.id
    except
    select /*+ use_hash ordered parallel(4) */
      a.id as a_id, a.fk as a_fk, b.id as b_id, b.val as b_val
    from t_p a left outer join t_b b on a.fk = b.id
  );
-- expected: 0

set system parameters 'max_hash_list_scan_size=default';

drop table t_b, t_p;
