/*
 * CBRD-26719 - single-context parallel probe baseline (INNER)
 *   covers: C1, with both the text and the JSON trace
 *
 * Key points:
 *   - small build side, so no partition is created and the single-context path is taken
 *   - large probe side, so parallel(N) has something to spread across workers
 *   - the JSON form goes through the single-context num_parallel_threads > 1 branch
 *
 * Judged by the answer file:
 *   - count(*) 100000, both EXCEPT directions 0
 *   - a worker sub-line on the line directly below PROBE
 *   - no "parallel workers" on the HASHJOIN line, no SPLIT and no PARALLEL node. Those three
 *     mark partition parallelism, so seeing them here would mean the wrong path was taken
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_b, t_p;

create table t_b (ckey int, cval int);
create table t_p (ckey int, cval int);

insert into t_b
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, n * 10 from cte;

insert into t_p
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 200) + 1 from cte a, cte b limit 100000;

update statistics on t_b, t_p with fullscan;

set system parameters 'max_hash_list_scan_size=8M'; -- default value, so no partitioning

set trace on;

evaluate 'Case 1: INNER join, parallel probe active - text trace';

select /*+ recompile use_hash ordered parallel(4)
           no_parallel_scan no_parallel_subquery */
  count (*)
from t_p a, t_b b where a.cval = b.ckey;
show trace;

evaluate 'Case 2: same query as JSON trace - single-context num_parallel_threads branch';

set trace on output json;

select /*+ recompile use_hash ordered parallel(4)
           no_parallel_scan no_parallel_subquery */
  count (*)
from t_p a, t_b b where a.cval = b.ckey;
show trace;

set trace off;

evaluate 'Case 3: trace is off from here - row set equality both ways, each result must be 0';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.ckey as bc1, b.cval as bc2
    from t_p a, t_b b where a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.ckey as bc1, b.cval as bc2
    from t_p a, t_b b where a.cval = b.ckey
  );
-- expected: 0

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.ckey as bc1, b.cval as bc2
    from t_p a, t_b b where a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.ckey as bc1, b.cval as bc2
    from t_p a, t_b b where a.cval = b.ckey
  );
-- expected: 0

set system parameters 'max_hash_list_scan_size=default';

drop table t_b, t_p;
