/*
 * CBRD-26719 - several hash joins in one query, each eligible for its own single-context
 *   parallel probe
 *   covers: C8 from the positive side (two hash join nodes side by side, not a PARTITION re-entry)
 *
 * Key points:
 *   - each node reserves its own workers, so with the default pool (max_parallel_workers=100)
 *     both run in parallel. This case does not verify the "pool reservation fails, so fall back"
 *     path - entry condition (3) needs several sessions competing at once, which a single-session
 *     SQL runner cannot reach. That one belongs to
 *     cubrid-testcases-private-ex/shell/_40_guava/cbrd_26719
 *   - both EXCEPT directions are asserted. One direction alone would only show that the parallel
 *     result is a subset of the serial one, so a parallel run that dropped rows would still pass.
 *     This is the only case with nested hash joins, where that risk is highest
 *
 * Judged by the answer file:
 *   - count(*) 80000, both EXCEPT directions 0
 *   - two PROBE lines, each carrying a worker sub-line on the next line
 *   - neither HASHJOIN line carries "parallel workers", and there is no SPLIT
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_ba, t_bb, t_p;

create table t_ba (ckey int, cval int);
create table t_bb (ckey int, cval int);
create table t_p  (ckey int, cval int);

insert into t_ba
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
  select n, n from cte;

insert into t_bb
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
  select n, n * 2 from cte;

insert into t_p
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 100) + 1 from cte a, cte b limit 80000;

update statistics on t_ba, t_bb, t_p with fullscan;

set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: two hash joins in one query - both run a parallel probe';

select /*+ recompile use_hash ordered parallel(4)
           no_parallel_scan no_parallel_subquery */
  count (*)
from t_p a, t_ba ba, t_bb bb
where a.cval = ba.ckey and a.cval = bb.ckey;
show trace;

set trace off;

evaluate 'Case 2: trace is off from here - row set equality both ways, each result must be 0';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, ba.ckey as bakey, bb.ckey as bbkey
    from t_p a, t_ba ba, t_bb bb where a.cval = ba.ckey and a.cval = bb.ckey
    except
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, ba.ckey as bakey, bb.ckey as bbkey
    from t_p a, t_ba ba, t_bb bb where a.cval = ba.ckey and a.cval = bb.ckey
  );
-- expected: 0

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, ba.ckey as bakey, bb.ckey as bbkey
    from t_p a, t_ba ba, t_bb bb where a.cval = ba.ckey and a.cval = bb.ckey
    except
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, ba.ckey as bakey, bb.ckey as bbkey
    from t_p a, t_ba ba, t_bb bb where a.cval = ba.ckey and a.cval = bb.ckey
  );
-- expected: 0

set system parameters 'max_hash_list_scan_size=default';

drop table t_ba, t_bb, t_p;
