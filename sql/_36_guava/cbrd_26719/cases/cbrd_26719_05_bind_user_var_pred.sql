/*
 * CBRD-26719 - single-context parallel probe with a during_join_pred that uses bind and user
 *   variables
 *   covers: a C6 variant (host and user variable propagation across workers)
 *   reference: CBRD-25717, cbrd_25717_during_join_predicates.sql, Case 4 and Case 5, reworked
 *              for the single-context path
 *
 * Key points:
 *   - if a host variable binding is shared between workers or gets lost, the result rows diverge
 *   - the LEFT OUTER is kept as is. The April attachment carried a "where b.id is not null" that
 *     collapsed the join into an INNER join, so the workers never evaluated the host variable on
 *     the NULL-fill path. The NULL-fill is observed through the aggregates instead
 *
 * Judged by the answer file:
 *   - total 80000, matched 49999 (10000 < a.id < 60000), identical in Cases 1, 2 and 3
 *   - a worker sub-line below PROBE in Cases 1 and 2, and no SPLIT
 *
 * Source: JIRA attachment cbrd-26719_test-case_20260921.zip (ported to CTP)
 */

drop table if exists t_b, t_p;

create table t_b (id int, ckey int);
create table t_p (id int, ckey int);

insert into t_b
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
  select n, n from cte;

insert into t_p
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 100) + 1 from cte a, cte b limit 80000;

update statistics on t_b, t_p with fullscan;

set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: bind variable inside during_join_pred - parallel probe';

prepare q from '
  select /*+ recompile use_hash ordered parallel(4)
             no_parallel_scan no_parallel_subquery */
    count (*) as total, count (b.id) as matched
  from t_p a left outer join t_b b on a.ckey = b.id and a.id > ? and a.id < ?';
execute q using 10000, 60000;
show trace;
deallocate prepare q;

evaluate 'Case 2: user variable inside during_join_pred - parallel probe';

set @lo = 10000;
set @hi = 60000;

select /*+ recompile use_hash ordered parallel(4)
           no_parallel_scan no_parallel_subquery */
  count (*) as total, count (b.id) as matched
from t_p a left outer join t_b b on a.ckey = b.id and a.id > @lo and a.id < @hi;
show trace;

evaluate 'Case 3: same user-variable join single-threaded - must match Case 2';

select /*+ recompile use_hash ordered parallel(0) */
  count (*) as total, count (b.id) as matched
from t_p a left outer join t_b b on a.ckey = b.id and a.id > @lo and a.id < @hi;

set trace off;

set system parameters 'max_hash_list_scan_size=default';

drop table t_b, t_p;
drop variable @lo, @hi;
