/*
 * This test case verifies CBRD-26964 : cache-line aligned allocation in the
 * memory wrapper (cub_aligned_alloc, base/memory_cwrapper.h).
 *
 * The wrapper gained a posix_memalign based allocation that is tracked by
 * the memory monitor like malloc, and page_buffer.c uses it to 64-byte
 * align the per-thread sharded SHOW PAGE BUFFER STATUS counters
 * (CBRD-26898) that every page fix of every worker thread updates. The
 * change has no SQL-visible specification: it only changes where the
 * structures live in memory. This case is therefore an allocation-path
 * smoke test: it runs the queries that drive many worker threads through
 * page fixes at the same time - parallel heap scans with aggregate,
 * mergeable-list and GROUP BY gathers over a table above the 32-page
 * test_mode scan threshold - and checks that their results equal the
 * serial results and the values that follow from the data definition.
 * A wrong alignment, a broken size round-up or a free of the wrong pointer
 * would crash the server or corrupt the counters on this path.
 *
 * Data: 8,000 rows, about 64 heap pages (100-byte pad),
 *       id = 1..8000, k = id mod 400 (400 keys x 20 rows), v = id mod 10.
 *
 *   Case 1: aggregate heap scan, parallel vs NO_PARALLEL_SCAN
 *   Case 2: PARALLEL(4) hint with DISTINCT aggregates
 *   Case 3: GROUP BY over the parallel mergeable list
 *   Case 4: parallel scan of the outer table of a join
 */

drop table if exists px_al_t;

create table px_al_t (id int, k int, v int, pad char(100));
insert into px_al_t select rownum, mod(rownum, 400), mod(rownum, 10), lpad('x', 100, 'x')
  from db_class a, db_class b, db_class c, db_class d limit 8000;

-- Case 1: aggregate heap scan, expected 8000, 36000, 0, 399, 32004000
evaluate '[1] aggregate heap scan: parallel / serial reference';
select count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(id) sum_id from px_al_t;
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(v) sum_v, min(k) min_k, max(k) max_k, sum(id) sum_id from px_al_t;

-- Case 2: explicit degree with DISTINCT aggregates, expected 400, 45, 79800
evaluate '[2] PARALLEL(4) with DISTINCT aggregates';
select /*+ PARALLEL(4) */ count(distinct k) cntd_k, sum(distinct v) sumd_v, sum(distinct k) sumd_k from px_al_t;

-- Case 3: GROUP BY over the mergeable list, expected 400 groups, 8000 rows, 20 / 20, sum k 79800
evaluate '[3] GROUP BY over the parallel mergeable list';
select count(*) grp_cnt, sum(cnt) row_cnt, min(cnt) min_cnt, max(cnt) max_cnt, sum(kk) sum_k
  from (select k kk, count(*) cnt from px_al_t group by k) d;

-- Case 4: parallel scan of the outer table of a join, expected 16000 rows (800 outer rows with v = 0, each joins the 20 rows of its key), sum of inner ids 64080000
evaluate '[4] join whose outer table is scanned in parallel';
select /*+ PARALLEL(4) */ count(*) cnt, sum(i.id) sum_inner_id from px_al_t o, px_al_t i where o.k = i.k and o.v < 1;

drop table px_al_t;
