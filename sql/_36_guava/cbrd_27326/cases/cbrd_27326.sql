/*
 * This test case verifies CBRD-27326 : the parallel execution entry
 * thresholds were lowered from 2048 pages (32MB) to 256 pages (4MB).
 *
 * compute_parallel_degree (px_parallel.cpp) decides the degree of a
 * parallel heap scan, a parallel hash join and a parallel sort from the
 * number of pages of its input and one threshold parameter each:
 *   parallel_scan_page_threshold      (heap data pages of the scanned class,
 *                                      also used by UPDATE STATISTICS /
 *                                      histogram collection)
 *   parallel_hash_join_page_threshold (pages of the larger join input list)
 *   parallel_sort_page_threshold      (pages of the sort input list)
 * The defaults went 2048 -> 256 in two steps (#7817 scan, #7964 hash join
 * and sort), so scans, joins and sorts between 4MB and 32MB that used to run
 * serially now run with 2 to 4 workers, and larger ones get a higher degree.
 * degree = floor(log2(pages / threshold)) + 2, capped by the parallelism
 * parameter and the core count.
 *
 * The three parameters are hidden, server-only, not changeable per session
 * and read once per server lifetime (call_once), so this case cannot set
 * them. Under test_mode (CTP) they are 32 / 0 / 0 pages. The data is sized
 * so that the case is meaningful under both settings:
 *   px_thr_hi  12,000 rows x 500-byte pad ~ 390 heap pages : above 256
 *   px_thr_mid  6,000 rows x 500-byte pad ~ 195 heap pages : between 32 and 256
 *   px_thr_lo     600 rows x 500-byte pad ~  20 heap pages : below 32
 * Under test_mode hi and mid are scanned / joined / sorted in parallel and lo
 * stays serial, with the new production defaults only hi is parallel, with
 * the old defaults everything was serial. Whatever the degree, every query
 * must return the same rows, so each check runs the query with the parallel
 * path disabled by hint (NO_PARALLEL_SCAN, NO_PARALLEL_HASH_JOIN, PARALLEL(1))
 * and with the automatic degree, and prints order-independent checksums.
 * Worker counts or degrees never appear in the answer.
 *
 * Data: hi.k = 1..12000, mid.k = 2, 4, ..., 12000, lo.k = 1..600,
 *       v = id mod 100 in every table, pad = 500 repeated letters.
 *
 *   Case 1: aggregate heap scan (buildvalue gather) on each table
 *   Case 2: filtered row-producing heap scan (mergeable list gather)
 *   Case 3: hash join hi x mid on k, both pads in the join lists (~ 375 pages
 *           each, above 256) -> 6,000 matches
 *   Case 4: ORDER BY of hi with its pad in the sort input (~ 375 pages)
 *   Case 5: UPDATE STATISTICS WITH FULLSCAN on all three tables (the scan
 *           threshold also gates the parallel statistics collection) and the
 *           queries of case 1 and 3 again with the fresh statistics
 */

drop table if exists px_thr_hi, px_thr_mid, px_thr_lo;

create table px_thr_hi  (k int, v int, pad char(500));
create table px_thr_mid (k int, v int, pad char(500));
create table px_thr_lo  (k int, v int, pad char(500));

insert into px_thr_hi  select rownum, mod(rownum, 100), lpad('h', 500, 'h') from db_class a, db_class b, db_class c, db_class d limit 12000;
insert into px_thr_mid select rownum * 2, mod(rownum, 100), lpad('m', 500, 'm') from db_class a, db_class b, db_class c, db_class d limit 6000;
insert into px_thr_lo  select rownum, mod(rownum, 100), lpad('l', 500, 'l') from db_class a, db_class b, db_class c limit 600;

-- Case 1: aggregate heap scan on each table
--         expected hi : 12000, 594000, 1, 12000, 6000000
--         expected mid:  6000, 297000, 2, 12000, 3000000
--         expected lo :   600,  29700, 1,   600,  300000
evaluate '[1] aggregate heap scan: serial reference (NO_PARALLEL_SCAN) / automatic degree';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_hi;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_hi;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_mid;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_mid;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_lo;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_lo;

-- Case 2: filtered row-producing heap scan (v < 10 keeps 10 of every 100 rows)
--         expected hi : 1200 rows, sum k 7157400, pad 600000 , mid: 600 rows, sum k 3557400, pad 300000 , lo: 60 rows, sum k 15870, pad 30000
evaluate '[2] filtered row-producing heap scan: serial reference / automatic degree';
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_PARALLEL_SCAN */ k, pad from px_thr_hi where v < 10) d;
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select k, pad from px_thr_hi where v < 10) d;
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_PARALLEL_SCAN */ k, pad from px_thr_mid where v < 10) d;
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select k, pad from px_thr_mid where v < 10) d;
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_PARALLEL_SCAN */ k, pad from px_thr_lo where v < 10) d;
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select k, pad from px_thr_lo where v < 10) d;

-- Case 3: hash join hi x mid on k, the pads travel in both join lists so each list is ~375 pages
--         expected: 6000 rows, sum(h.v + m.v) 591000, sum of pad lengths 6000000, sum k 36006000
evaluate '[3] hash join with ~375-page inputs: serial reference (NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN) / automatic degree';
select /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN */ count(*) cnt, sum(h.v + m.v) sum_v, sum(length(h.pad) + length(m.pad)) sum_pad, sum(h.k) sum_k
  from px_thr_hi h, px_thr_mid m where h.k = m.k;
select /*+ USE_HASH */ count(*) cnt, sum(h.v + m.v) sum_v, sum(length(h.pad) + length(m.pad)) sum_pad, sum(h.k) sum_k
  from px_thr_hi h, px_thr_mid m where h.k = m.k;

-- Case 4: ORDER BY of hi with the pad in the sort input (~375 pages), NO_MERGE keeps the derived table's ORDER BY
--         expected: 12000 rows, sum k 72006000, sum pad 6000000, max/min k 12000 / 1
evaluate '[4] ORDER BY with a ~375-page sort input: serial reference (PARALLEL(1)) / automatic degree';
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad, min(k) min_k, max(k) max_k
  from (select /*+ NO_MERGE PARALLEL(1) */ k, v, pad from px_thr_hi order by v desc, k) d;
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad, min(k) min_k, max(k) max_k
  from (select /*+ NO_MERGE */ k, v, pad from px_thr_hi order by v desc, k) d;

-- Case 5: UPDATE STATISTICS WITH FULLSCAN (parallel collection above the scan threshold), then re-run
--         expected: same values as case 1 (hi, mid) and case 3
evaluate '[5] UPDATE STATISTICS WITH FULLSCAN on all three tables, then the aggregate and the join again';
update statistics on px_thr_hi, px_thr_mid, px_thr_lo with fullscan;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_hi;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_mid;
select /*+ USE_HASH recompile */ count(*) cnt, sum(h.v + m.v) sum_v, sum(length(h.pad) + length(m.pad)) sum_pad, sum(h.k) sum_k
  from px_thr_hi h, px_thr_mid m where h.k = m.k;

drop table px_thr_hi, px_thr_mid, px_thr_lo;
