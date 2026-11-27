/*
 * This test case verifies CBRD-27326 : the parallel execution entry
 * thresholds were lowered from 2048 pages (32MB) to 256 pages (4MB).
 *
 * compute_parallel_degree (px_parallel.cpp) decides the degree of a
 * parallel heap scan, a parallel hash join and a parallel sort from the
 * number of pages of its input and one threshold parameter each:
 *   parallel_scan_page_threshold      (heap data pages of the scanned class,
 *                                      also used by the UPDATE STATISTICS
 *                                      collection scan)
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
 * them. Under test_mode (CTP) prm_tune_parameters forces them to 32 / 0 / 0
 * and a threshold of 0 acts as 2 pages, so under CTP every hash join and
 * sort with a 2-page input is parallel and only the scan threshold (32) is a
 * real boundary. The 256 default itself is therefore not observable here,
 * it is checked by the shell case of the same name, which runs without
 * test_mode. This case checks that the parallel paths which the lowered
 * thresholds enable return the same rows as the serial paths, and the
 * traces fix which path ran.
 *
 * The pad is a chain of SHA-2 digests, so it is not compressed on disk
 * (a repeated-letter pad is LZ4-compressed to ~48 bytes and the tables
 * shrink to a tenth of the intended size). Measured with SHOW HEAP CAPACITY
 * (16KB pages, avg record 548 bytes, ~26 records per page):
 *   px_thr_hi  12,000 rows ~ 465 heap pages : above 256 and 32
 *   px_thr_mid  5,000 rows ~ 193 heap pages : between 32 and 256
 *   px_thr_lo     500 rows ~  20 heap pages : below 32
 * Under test_mode hi and mid are scanned in parallel and lo stays serial,
 * with the production defaults (256) only hi is parallel. The join lists
 * and the sort input carry the pad, so for hi they are also ~465 pages.
 *
 * Every check runs the query with the parallel path disabled by hint
 * (NO_PARALLEL_SCAN, NO_PARALLEL_HASH_JOIN, NO_PARALLEL_SUBQUERY,
 * PARALLEL(1)) and with the automatic degree, and prints order-independent
 * checksums. The hi and lo queries are traced. In the traced automatic
 * variant every other parallel path is disabled by hint, so the hi trace
 * must contain exactly one "parallel workers" line, under the node that
 * the threshold under test admitted (SCAN with "gather: buildvalue" or
 * "gather: mergeable list", HASHJOIN PROBE, ORDERBY), and the lo trace and
 * every serial reference must contain none. CTP masks the numbers of the
 * trace (worker counts, times, pages), so the answer does not depend on the
 * core count or the degree. mid is not traced because its scan is parallel
 * only under test_mode. The untraced "all automatic" variants additionally
 * check the result when every path is parallel at once.
 *
 * Data: hi.k = 1..12000, mid.k = 2, 4, ..., 10000, lo.k = 1..500,
 *       v = id mod 100 in every table, pad = 512 hex characters.
 *
 *   Case 1: aggregate heap scan (gather: buildvalue) on each table
 *   Case 2: filtered row-producing heap scan (NO_MERGE keeps the derived
 *           table, gather: mergeable list) on each table
 *   Case 3: hash join hi x mid on k, both pads in the join lists, so the
 *           larger list is ~465 pages -> 5,000 matches, PROBE is parallel
 *   Case 4: ORDER BY of hi with its pad in the sort input (~465 pages),
 *           besides the checksums the position of every row in the sorted
 *           list is compared with the position computed from (v, k), so a
 *           parallel sort that returns all rows in a wrong order fails
 *   Case 5: UPDATE STATISTICS WITH FULLSCAN on all three tables (one full
 *           heap scan per table, split over workers above the scan
 *           threshold, no trace is available for it) and the queries of
 *           case 1 and 3 again with the fresh statistics
 */

drop table if exists px_thr_hi, px_thr_mid, px_thr_lo;

create table px_thr_hi  (k int, v int, pad varchar(512));
create table px_thr_mid (k int, v int, pad varchar(512));
create table px_thr_lo  (k int, v int, pad varchar(512));

insert into px_thr_hi  select rownum, mod(rownum, 100), sha2(rownum, 512) || sha2(rownum + 1, 512) || sha2(rownum + 2, 512) || sha2(rownum + 3, 512) from db_class a, db_class b, db_class c, db_class d limit 12000;
insert into px_thr_mid select rownum * 2, mod(rownum, 100), sha2(rownum * 2, 512) || sha2(rownum * 2 + 1, 512) || sha2(rownum * 2 + 2, 512) || sha2(rownum * 2 + 3, 512) from db_class a, db_class b, db_class c, db_class d limit 5000;
insert into px_thr_lo  select rownum, mod(rownum, 100), sha2(rownum, 512) || sha2(rownum + 1, 512) || sha2(rownum + 2, 512) || sha2(rownum + 3, 512) from db_class a, db_class b, db_class c limit 500;

-- the pad must not be compressed: every row keeps its 512 bytes
select count(*) rows_hi, min(length(pad)) min_pad, max(length(pad)) max_pad, count(distinct pad) distinct_pad from px_thr_hi;

set trace on;

-- Case 1: aggregate heap scan on each table
--         expected hi : 12000, 594000, 1, 12000, 6144000
--         expected mid:  5000, 247500, 2, 10000, 2560000
--         expected lo :   500,  24750, 1,   500,  256000
--         trace: hi automatic = SCAN with "parallel workers" and "gather: buildvalue"; hi serial and lo = none
evaluate '[1] aggregate heap scan: serial reference (NO_PARALLEL_SCAN) / automatic degree';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_hi;
show trace;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_hi;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_mid;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_mid;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_lo;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_lo;
show trace;

-- Case 2: filtered row-producing heap scan (v < 10 keeps 10 of every 100 rows), NO_MERGE keeps the derived table.
--         The outer NO_PARALLEL_SCAN keeps the scan of the derived list serial, so only the heap scan is automatic.
--         expected hi : 1200 rows, sum k 7157400, pad 614400 , mid: 500 rows, sum k 2464500, pad 256000 , lo: 50 rows, sum k 10725, pad 25600
--         trace: hi automatic = SCAN (table) with "parallel workers" and "gather: mergeable list"; hi serial and lo = none
evaluate '[2] filtered row-producing heap scan: serial reference (NO_PARALLEL_SCAN) / automatic degree';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_MERGE NO_PARALLEL_SCAN */ k, pad from px_thr_hi where v < 10) d;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_MERGE */ k, pad from px_thr_hi where v < 10) d;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_MERGE NO_PARALLEL_SCAN */ k, pad from px_thr_mid where v < 10) d;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_MERGE */ k, pad from px_thr_mid where v < 10) d;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_MERGE NO_PARALLEL_SCAN */ k, pad from px_thr_lo where v < 10) d;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad from (select /*+ NO_MERGE */ k, pad from px_thr_lo where v < 10) d;
show trace;

-- Case 3: hash join hi x mid on k, the pads travel in both join lists so the larger list is ~465 pages.
--         serial reference / hash join only (scans and the input subqueries stay serial) / everything automatic
--         expected: 5000 rows, sum(h.v + m.v) 492500, sum of pad lengths 5120000, sum k 25005000
--         trace: hash join only = HASHJOIN PROBE with "parallel workers"; serial reference = none
evaluate '[3] hash join with a ~465-page input: serial reference (NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY) / hash join only / automatic degree';
select /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ count(*) cnt, sum(h.v + m.v) sum_v, sum(length(h.pad) + length(m.pad)) sum_pad, sum(h.k) sum_k
  from px_thr_hi h, px_thr_mid m where h.k = m.k;
show trace;
select /*+ USE_HASH NO_PARALLEL_SCAN NO_PARALLEL_SUBQUERY */ count(*) cnt, sum(h.v + m.v) sum_v, sum(length(h.pad) + length(m.pad)) sum_pad, sum(h.k) sum_k
  from px_thr_hi h, px_thr_mid m where h.k = m.k;
show trace;
select /*+ USE_HASH */ count(*) cnt, sum(h.v + m.v) sum_v, sum(length(h.pad) + length(m.pad)) sum_pad, sum(h.k) sum_k
  from px_thr_hi h, px_thr_mid m where h.k = m.k;

-- Case 4: ORDER BY of hi with the pad in the sort input (~465 pages), NO_MERGE keeps the derived table's ORDER BY.
--         serial reference (PARALLEL(1)) / sort only (the heap scan and the scan of the sorted list stay serial) / everything automatic
--         expected: 12000 rows, sum k 72006000, sum pad 6144000, max/min k 12000 / 1
--         trace: sort only = ORDERBY with "parallel workers"; serial reference = none
--         order check: row n of "order by v desc, k" must have n = (99 - v) * 120 + (k - v) / 100 + (v > 0),
--         i.e. the 120 rows with v = 99 come first (k = 99, 199, ..., 11999), then v = 98, ..., v = 0 (k = 100, ..., 12000);
--         expected: 12000 rows, 0 rows out of order (a wrong order such as "order by v, k" reports 12000)
evaluate '[4] ORDER BY with a ~465-page sort input: serial reference (PARALLEL(1)) / sort only / automatic degree';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad, min(k) min_k, max(k) max_k
  from (select /*+ NO_MERGE PARALLEL(1) */ k, v, pad from px_thr_hi order by v desc, k) d;
show trace;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad, min(k) min_k, max(k) max_k
  from (select /*+ NO_MERGE NO_PARALLEL_SCAN */ k, v, pad from px_thr_hi order by v desc, k) d;
show trace;
select count(*) cnt, sum(k) sum_k, sum(length(pad)) sum_pad, min(k) min_k, max(k) max_k
  from (select /*+ NO_MERGE */ k, v, pad from px_thr_hi order by v desc, k) d;
select count(*) cnt, sum(case when rn = (99 - v) * 120 + (k - v) / 100 + (case when v > 0 then 1 else 0 end) then 0 else 1 end) out_of_order
  from (select k, v, rownum rn from (select /*+ NO_MERGE PARALLEL(1) */ k, v, pad from px_thr_hi order by v desc, k) x) d;
select count(*) cnt, sum(case when rn = (99 - v) * 120 + (k - v) / 100 + (case when v > 0 then 1 else 0 end) then 0 else 1 end) out_of_order
  from (select k, v, rownum rn from (select /*+ NO_MERGE */ k, v, pad from px_thr_hi order by v desc, k) x) d;

set trace off;

-- Case 5: UPDATE STATISTICS WITH FULLSCAN (the collection scan is split over workers above the scan threshold), then re-run
--         expected: same values as case 1 (hi, mid) and case 3
evaluate '[5] UPDATE STATISTICS WITH FULLSCAN on all three tables, then the aggregate and the join again';
update statistics on px_thr_hi, px_thr_mid, px_thr_lo with fullscan;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_hi;
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(length(pad)) sum_pad from px_thr_mid;
select /*+ USE_HASH recompile */ count(*) cnt, sum(h.v + m.v) sum_v, sum(length(h.pad) + length(m.pad)) sum_pad, sum(h.k) sum_k
  from px_thr_hi h, px_thr_mid m where h.k = m.k;

drop table px_thr_hi, px_thr_mid, px_thr_lo;
