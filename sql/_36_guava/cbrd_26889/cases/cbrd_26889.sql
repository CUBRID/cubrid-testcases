/*
 * This test case verifies CBRD-26889 : a NON-covering index scan on a selective
 * equality predicate degraded into a full heap scan when the statistics of the
 * indexed column were stale (collected while the column had few distinct
 * values).
 *
 * Bug: qo_iscan_cost () bounds the key-range selectivity from below by the
 * average key share 1 / pkeys[0] of the index statistics. With stale
 * statistics saying NDV = 10, a predicate that really matches one row is
 * priced as 10% of the table, and the per-row heap-access CPU penalty of a
 * non-covering index scan (ISCAN_OID_ACCESS_OVERHEAD, then 20 per row) pushed
 * the index scan above the sequential scan, so the natural plan became sscan.
 *
 * Fix: ISCAN_OID_ACCESS_OVERHEAD was lowered from 20 to 5 in
 * query_planner.c. At 10% estimated selectivity the index scan is now cheaper
 * than the sequential scan (heap CPU 6 units per fetched row vs 1 unit per
 * scanned row: 0.1 * 6 < 1), while at 20 it was not (0.1 * 21 > 1).
 * This is different from CBRD-27113 (per-row heap-fetch and per-probe leaf
 * cost model): here the statistics are deliberately WRONG and the check is
 * that the constant keeps the index scan competitive at a 10% estimate.
 *
 * Data: oa_t gets 30,000 rows with k = id mod 10 (NDV 10). Statistics are
 * collected WITH FULLSCAN, NO HISTOGRAM (NCARD 30,000, pkeys[0] = 10, no
 * histogram so the estimate is exactly 1/NDV and the 1/pkeys floor path is
 * the one exercised). Then 10,000 rows with distinct k values 30000..39999 are
 * inserted WITHOUT updating statistics. The query k = 35000 matches one row,
 * but the optimizer still estimates 10% (3,000 heap fetches over ~230 pages).
 *   Case 1: non-covering lookup (id, pad) with stale statistics
 *           -> iscan on i_oa_t_k. A regression (constant raised again) shows
 *           sscan: the heap CPU penalty exceeds the full-scan cost.
 *   Case 2: covering lookup (k only) with the same statistics -> iscan
 *           (covers). Covering scans pay no heap penalty, so this stays
 *           iscan under any value of the constant (control).
 *   Case 3: after UPDATE STATISTICS the estimate is 1/10010 and the
 *           non-covering lookup is iscan with correct statistics (control).
 */
drop table if exists oa_t, oa_d;

create table oa_d (n int primary key);
insert into oa_d values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

create table oa_t (id int primary key, k int, pad char(100));
create index i_oa_t_k on oa_t (k);

-- 30,000 rows, k has only 10 distinct values
insert into oa_t
select x.id, mod (x.id, 10), 'p'
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n + 10000 * j.n as id
      from oa_d a, oa_d b, oa_d c, oa_d e, oa_d j where j.n < 3) x;

-- statistics snapshot: NCARD 30000, pkeys[0] = 10
update statistics on oa_t with fullscan, no histogram;

-- 10,000 more rows with distinct k values, statistics are NOT refreshed
insert into oa_t
select 30000 + x.id, 30000 + x.id, 'q'
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n as id from oa_d a, oa_d b, oa_d c, oa_d e) x;

select count(*) from oa_t;
select count(*) from oa_t where k = 35000;

-- Case 1: stale NDV 10 -> estimated 10%, non-covering -> must still be iscan
evaluate '[1] stale statistics (NDV 10), non-covering lookup: iscan on i_oa_t_k';
--@queryplan
select /*+ recompile */ id, pad from oa_t where k = 35000;

-- Case 2: covering lookup, same statistics (control: no heap penalty)
evaluate '[2] stale statistics, covering lookup: iscan (covers)';
--@queryplan
select /*+ recompile */ k from oa_t where k = 35000;

-- Case 3: fresh statistics (NDV 10010) -> iscan with the correct estimate
update statistics on oa_t with fullscan, no histogram;

evaluate '[3] fresh statistics, non-covering lookup: iscan on i_oa_t_k';
--@queryplan
select /*+ recompile */ id, pad from oa_t where k = 35000;

drop table oa_t, oa_d;
