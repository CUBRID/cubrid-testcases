/*
 * This test case verifies CBRD-26889 : the per-row heap-access CPU penalty of a
 * NON-covering index scan (ISCAN_OID_ACCESS_OVERHEAD, now the parameter
 * cost_heap_fetch_per_oid) was 20, which priced an index range scan above the
 * sequential scan already at about 10% selectivity, while the index scan is
 * measured to be faster up to about 25%.
 *
 * Fix: the penalty was lowered from 20 to 5 (query_planner.c, PR #7262).
 *
 * The case uses ordinary statistics (UPDATE STATISTICS ... WITH FULLSCAN), so it
 * does not depend on stale or missing statistics: the range selectivity is
 * estimated correctly (15% -> 3,000 of 20,000 rows) and only the penalty decides
 * between the two plans.
 *
 * Data: oa_t has 20,000 rows, k = id div 100 (200 values, 100 rows each),
 * about 190 heap pages (below parallel_scan_page_threshold, so the plans are
 * serial and stable).
 *
 * Measured on a release build (median of 30 warm runs, 2026-10-19):
 *   15% range: iscan 0.007 s, sscan 0.012 s -> iscan is the faster plan
 *   50% range: sscan is the faster plan
 *
 *   Case 1: 15% range, non-covering -> iscan on i_oa_t_k (a penalty of 20
 *           chooses sscan here)
 *   Case 2: 50% range, non-covering -> sscan (control: a wide range still
 *           goes to the full scan)
 *   Case 3: Case 1 with cost_heap_fetch_per_oid = 20 -> sscan (shows that the
 *           penalty alone flips the plan of Case 1)
 */
drop table if exists oa_t, oa_d;

create table oa_d (n int primary key);
insert into oa_d values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

create table oa_t (id int primary key, k int, pad char(100));

-- 20,000 rows, k = id div 100
insert into oa_t
select x.id, x.id div 100, 'p'
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n + 10000 * f.n as id
      from oa_d a, oa_d b, oa_d c, oa_d e, oa_d f where f.n < 2) x;

create index i_oa_t_k on oa_t (k);

update statistics on oa_t with fullscan;

select count(*), count(distinct k) from oa_t;

-- Case 1: 15% range, non-covering -> iscan
evaluate '[1] 15% range, non-covering: iscan on i_oa_t_k';
--@queryplan
select /*+ recompile */ count(pad) from oa_t where k between 0 and 29;

-- Case 2: 50% range, non-covering -> sscan (control)
evaluate '[2] 50% range, non-covering: sscan';
--@queryplan
select /*+ recompile */ count(pad) from oa_t where k between 0 and 99;

-- Case 3: the old penalty 20 turns Case 1 into sscan
set system parameters 'cost_heap_fetch_per_oid=20';

evaluate '[3] 15% range with cost_heap_fetch_per_oid=20: sscan';
--@queryplan
select /*+ recompile */ count(pad) from oa_t where k between 0 and 29;

set system parameters 'cost_heap_fetch_per_oid=5';

drop table oa_t, oa_d;
