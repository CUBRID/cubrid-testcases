/*
 * CBRD-26719 - single-context parallel probe with a RIGHT OUTER join, parallel probe running
 *   covers: A/C (2), NULL-fill and during_join_pred residual evaluation for right-outer joins
 *
 * Key points:
 *   - the attachment's only right outer join is 08_empty_input_outer, which has an empty input
 *     and falls into the NULL-fill bypass. That path skips build and probe, so the parallel probe
 *     never applies. Of the three join shapes A/C (2) asks for, RIGHT OUTER was the one never
 *     verified with the parallel probe actually running
 *   - neither input is empty here, and the build side stays small to pin the single-context path
 *   - the null-supplying side keeps rows that find no partner, so the NULL-fill has to be spread
 *     correctly across workers
 *   - a variant with a during_join_pred is included as well
 *
 * Judged by the answer file:
 *   - Cases 1 and 2: total_rows 100000 / matched 50000 (probe keys 201..400 find no partner)
 *   - Cases 3 and 4: total_rows 100000 / matched 16500 (66 of the 200 build keys are multiples
 *     of 3, each met 250 times)
 *   - Case 5: both EXCEPT directions 0
 *   - a worker sub-line below PROBE in Cases 1 and 3 but not in Cases 2 and 4, and no SPLIT
 *
 * Prerequisite: CTP runs SQL tests with test_mode=yes, so prm_tune_parameters() lowers
 *   parallel_hash_join_page_threshold from its default 256 pages to 0 (floored to 2 by
 *   compute_parallel_degree). Without it the probe lists here stay under 256 pages and the
 *   parallel-probe cases fall back to a serial probe.
 *
 * Source: own addition (not in the JIRA attachment)
 */

drop table if exists t_ro_build, t_ro_probe;

create table t_ro_build (ckey int, cval int);
create table t_ro_probe (ckey int, cval int);

-- small build side: keys 1..200 only
insert into t_ro_build
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, n * 10 from cte;

-- large probe side: keys 1..400, so 201..400 find no partner
insert into t_ro_probe
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum, mod (rownum, 400) + 1 from cte a, cte b limit 100000;

update statistics on t_ro_build, t_ro_probe with fullscan;

-- default value, so no partitioning
set system parameters 'max_hash_list_scan_size=8M';

set trace on;

evaluate 'Case 1: RIGHT OUTER, parallel probe active - null-supplying side keeps unmatched rows';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows, count (b.ckey) as matched
from t_ro_build b right outer join t_ro_probe a on a.cval = b.ckey;

show trace;

evaluate 'Case 2: same RIGHT OUTER single-threaded - must match Case 1';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows, count (b.ckey) as matched
from t_ro_build b right outer join t_ro_probe a on a.cval = b.ckey;

show trace;

evaluate 'Case 3: RIGHT OUTER + during_join_pred - residual evaluated per worker';

--@queryplan
select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows, count (b.ckey) as matched
from t_ro_build b right outer join t_ro_probe a
  on a.cval = b.ckey and mod (a.cval, 3) = 0;

show trace;

evaluate 'Case 4: same RIGHT OUTER + during_join_pred single-threaded - must match Case 3';

--@queryplan
select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows, count (b.ckey) as matched
from t_ro_build b right outer join t_ro_probe a
  on a.cval = b.ckey and mod (a.cval, 3) = 0;

show trace;

set trace off;

evaluate 'Case 5: row set equality both ways (parallel EXCEPT serial, serial EXCEPT parallel)';

select count (*) as parallel_minus_serial
from (
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_ro_build b right outer join t_ro_probe a on a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_ro_build b right outer join t_ro_probe a on a.cval = b.ckey
  );

select count (*) as serial_minus_parallel
from (
    select /*+ use_hash ordered parallel(0) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_ro_build b right outer join t_ro_probe a on a.cval = b.ckey
    except
    select /*+ use_hash ordered parallel(4) */ a.ckey, a.cval, b.ckey as bckey, b.cval as bcval
    from t_ro_build b right outer join t_ro_probe a on a.cval = b.ckey
  );

set system parameters 'max_hash_list_scan_size=default';

drop table t_ro_build, t_ro_probe;
