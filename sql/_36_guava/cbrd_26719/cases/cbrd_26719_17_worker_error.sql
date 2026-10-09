/*
 * CBRD-26719 - an error raised inside a parallel-probe worker
 *   covers: error propagation and cleanup when a worker hits a runtime error during the probe
 *
 * Key points:
 *   - the during_join_pred casts a VARCHAR tag to INT; one probe row (id 12345) carries an
 *     uncastable 'x', so the cast fails inside whichever worker processes that row
 *   - the error must surface to the session (Case 1) and match the serial error text (Case 2)
 *   - the session must still be usable afterwards (Case 3)
 *   - with the failing row filtered out of the probe, the same shape runs the parallel probe
 *     cleanly (Case 4). a.id <> 12345 is a probe-only predicate, so it is pushed onto the probe
 *     scan and the uncastable row never reaches the cast - that is why Case 4 does not error
 *
 * Judged by the answer file:
 *   - Cases 1 and 2 both fail with the same error (CTP records it as Error:-181, the coerce error)
 *   - Case 3 returns 200 - the session survived the worker error
 *   - Case 4 returns total_rows 49999 / matched 49999 with a worker sub-line below PROBE
 *
 * Not recorded in the answer file:
 *   - which worker raised the error, and whether the others were still running - the trace of a
 *     failed query is not emitted. The verdict rests on the error text, the surviving session,
 *     and the clean Case 4 run
 *
 * Prerequisite: CTP runs SQL tests with test_mode=yes, so prm_tune_parameters() lowers
 *   parallel_hash_join_page_threshold from its default 256 pages to 0 (floored to 2 by
 *   compute_parallel_degree). Without it the probe lists here stay under 256 pages and the
 *   parallel-probe cases fall back to a serial probe.
 *
 * Source: own addition (proposed in the PR #3594 review)
 */

drop table if exists t_err_build, t_err_probe;

create table t_err_build (id int, ckey int);

insert into t_err_build
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
  select n, n from cte;

-- probe: 50000 rows, every ckey exists in build, one row carries a tag that cannot be cast to int
create table t_err_probe (id int, ckey int, tag varchar (10));

insert into t_err_probe
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 2000)
  select rownum,
         mod (rownum, 200) + 1,
         case when rownum = 12345 then 'x' else '1' end
  from cte a, cte b limit 50000;

update statistics on t_err_build, t_err_probe with fullscan;

-- default value, so no partitioning
set system parameters 'max_hash_list_scan_size=8M';

evaluate 'Case 1: during_join_pred fails inside a worker - the error must reach the session';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.id) as matched
from t_err_probe a left outer join t_err_build b
  on a.ckey = b.id and cast (a.tag as int) > 0;

evaluate 'Case 2: same failing join single-threaded - defines the expected error text';

select /*+ recompile use_hash ordered parallel(0) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.id) as matched
from t_err_probe a left outer join t_err_build b
  on a.ckey = b.id and cast (a.tag as int) > 0;

evaluate 'Case 3: the session is still usable after the worker error';

select count (*) from t_err_build;

set trace on;

evaluate 'Case 4: same shape with the failing row filtered out - parallel probe engages, no error';

select /*+ recompile use_hash ordered parallel(4) no_parallel_scan no_parallel_subquery */
  count (*) as total_rows,
  count (b.id) as matched
from t_err_probe a left outer join t_err_build b
  on a.ckey = b.id and cast (a.tag as int) > 0
where a.id <> 12345;

show trace;

set trace off;

set system parameters 'max_hash_list_scan_size=default';

drop table t_err_build, t_err_probe;
