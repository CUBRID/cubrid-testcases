/*
 * This test case verifies CBRD-26795 : parallel sort extended to GROUP BY,
 * ORDER BY ... LIMIT, analytic functions and DISTINCT ... LIMIT.
 *
 * Before the change only a plain ORDER BY sort could run on parallel sort
 * workers. The change (external_sort.c: sort_check_parallelism,
 * sort_start_parallelism, sort_end_parallelism) adds three sort types
 *   SORT_GROUP_BY         - the sort of a GROUP BY that is not hash-eligible
 *                           (NO_HASH_AGGREGATE hint, or hash aggregation
 *                           abandoned at run time)
 *   SORT_ORDER_WITH_LIMIT - ORDER BY + LIMIT whose result is estimated above
 *                           the in-memory top-N buffer (sort_buffer_size, 2MB)
 *   SORT_ANALYTIC         - the sort that feeds an analytic (OVER) function
 * and replaces the static page slicing by sector stealing (workers grab input
 * sectors with an atomic fetch_add) and the level-based fan-in by an async
 * 2-way queue merge. A defect in the distribution or in the merge shows up as
 * lost, duplicated or misordered tuples, so every check below runs the same
 * query twice: once with the PARALLEL(1) hint (a hint degree below 2 makes
 * compute_parallel_degree return 0 for the scan and for the sort, i.e. the
 * serial reference) and once with the default auto degree. Both runs print
 * order-independent checksums (count / sum / min / max) of the result, which
 * must be identical and equal to the values that follow from the data
 * definition (see the comments of each case).
 *
 * Under test_mode (CTP) parallel_sort_page_threshold is 0, so a sort whose
 * input list has at least 2 pages and more tuples than the degree is a
 * parallel-sort candidate on a host with 3 or more cores, ORDER BY ... LIMIT
 * additionally needs at least 500 input tuples (MIN_TUPLES_FOR_PARALLEL_SORT).
 * The table has 40,000 rows (about 320 heap pages, 100-byte pad, 8 bigint
 * filler columns). The filler columns keep the estimated ORDER BY ... LIMIT
 * result (88 bytes x 32,000 rows) above the 2MB top-N buffer so that the
 * external sort with limit really runs instead of the in-memory top-N heap.
 * Cases 3 and 4 reference every filler column and pad in the outer checksum:
 * an unreferenced select-list item of the non-mergeable inline view is pruned
 * by the rewriter (mq_remove_select_list_for_inline_view), which would shrink
 * the sorted tuple to (k, id) and send the query to the top-N heap instead.
 * count(distinct ...) catches a lost row paired with a duplicated one whose
 * values happen to keep the sums unchanged.
 * The answer never contains a worker count or degree, so it does not depend
 * on the number of cores.
 *
 * Data: id = 1..40000, grp = id mod 97 (97 groups of 412 or 413 rows),
 *       k = (id * 7919) mod 40000 (a permutation of 0..39999: unique),
 *       v = id mod 1000.
 *
 *   Case 1: GROUP BY + HAVING on the sort path (NO_HASH_AGGREGATE):
 *           36 groups (grp 1..36) have 413 rows
 *   Case 2: GROUP BY on the all-unique key k: hash aggregation is abandoned
 *           after 2,000 tuples and the partial list is sorted (SORT_GROUP_BY).
 *           Run three times: serial reference, NO_PARALLEL_SCAN (the leader
 *           abandons the hash itself, so the GROUP BY sort runs on parallel
 *           sort workers) and auto degree (a parallel heap scan aggregates in
 *           the workers' own hash contexts; the leader's context is left in
 *           HS_ACCEPT_ALL, so the GROUP BY sort itself currently stays serial)
 *   Case 3: ORDER BY k, id LIMIT 32000 on the unique key -> k = 0..31999
 *   Case 4: ORDER BY grp, id LIMIT 32000 on a key with ties, id as tiebreak
 *   Case 5: ROW_NUMBER() OVER (ORDER BY k) -> rn = k + 1 for every row
 *   Case 6: SUM(v) OVER (PARTITION BY grp ORDER BY id) running sum
 *   Case 7: DISTINCT grp ORDER BY grp LIMIT 50 -> grp 0..49
 */

drop table if exists px_sort_t;

create table px_sort_t (id int, grp int, k int, v int,
                        x1 bigint, x2 bigint, x3 bigint, x4 bigint,
                        x5 bigint, x6 bigint, x7 bigint, x8 bigint,
                        pad char(100));

insert into px_sort_t
  select rownum, mod(rownum, 97), mod(rownum * 7919, 40000), mod(rownum, 1000),
         rownum, rownum, rownum, rownum, rownum, rownum, rownum, rownum,
         lpad('x', 100, 'x')
  from db_class a, db_class b, db_class c, db_class d limit 40000;

select count(*), count(distinct k), min(k), max(k), count(distinct grp) from px_sort_t;

-- Case 1: GROUP BY + HAVING on the sort path (NO_HASH_AGGREGATE)
--         expected: 36 groups, 14868 rows, min grp 1, max grp 36
evaluate '[1] GROUP BY + HAVING, sort path (NO_HASH_AGGREGATE): serial reference';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k, min(g) min_grp, max(g) max_grp
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp having count(*) > 412) d;

evaluate '[1] GROUP BY + HAVING, sort path (NO_HASH_AGGREGATE): parallel';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k, min(g) min_grp, max(g) max_grp
  from (select /*+ NO_HASH_AGGREGATE */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp having count(*) > 412) d;

-- Case 2: GROUP BY on the all-unique key: hash aggregation abandoned, partial list sorted
--         expected: 40000 groups, 40000 rows, sum k 799980000, sum v 19980000
evaluate '[2] GROUP BY on an all-unique key (hash abandoned -> SORT_GROUP_BY): serial reference';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select /*+ PARALLEL(1) */ k kk, count(*) cnt, sum(v) sv from px_sort_t group by k having count(*) = 1) d;

evaluate '[2] GROUP BY on an all-unique key (hash abandoned -> SORT_GROUP_BY): parallel sort (NO_PARALLEL_SCAN)';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select /*+ NO_PARALLEL_SCAN */ k kk, count(*) cnt, sum(v) sv from px_sort_t group by k having count(*) = 1) d;

evaluate '[2] GROUP BY on an all-unique key (hash abandoned in the scan workers): parallel scan';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select k kk, count(*) cnt, sum(v) sv from px_sort_t group by k having count(*) = 1) d;

-- Case 3: ORDER BY k, id LIMIT 32000 (unique key, result estimate above the 2MB top-N buffer)
--         expected: 32000 rows, 32000 distinct k = 0..31999 (sum 511984000), sum_x = 8 * sum_id, pad length sum 3200000
evaluate '[3] ORDER BY unique key LIMIT 32000 (SORT_ORDER_WITH_LIMIT): serial reference';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(1) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 32000) d;

evaluate '[3] ORDER BY unique key LIMIT 32000 (SORT_ORDER_WITH_LIMIT): parallel';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 32000) d;

-- Case 4: ORDER BY grp, id LIMIT 32000: grp has ties (412/413 rows per value), id breaks them
--         expected: 32000 rows, 32000 distinct id, grp 0..77 (grp 77 only partially: 240 rows, last id 23260),
--                   sum_x = 8 * sum_id, pad length sum 3200000
evaluate '[4] ORDER BY key with ties + id tiebreak, LIMIT 32000: serial reference';
select count(*) cnt, count(distinct id) dist_id, sum(grp) sum_grp, max(grp) max_grp, sum(id) sum_id, sum(k) sum_k,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad,
       sum(case when grp = 77 then 1 else 0 end) rows_in_last_grp, max(case when grp = 77 then id else 0 end) max_id_in_last_grp
  from (select /*+ PARALLEL(1) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by grp, id limit 32000) d;

evaluate '[4] ORDER BY key with ties + id tiebreak, LIMIT 32000: parallel';
select count(*) cnt, count(distinct id) dist_id, sum(grp) sum_grp, max(grp) max_grp, sum(id) sum_id, sum(k) sum_k,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad,
       sum(case when grp = 77 then 1 else 0 end) rows_in_last_grp, max(case when grp = 77 then id else 0 end) max_id_in_last_grp
  from (select id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by grp, id limit 32000) d;

-- Case 5: ROW_NUMBER() OVER (ORDER BY k): k is a permutation of 0..39999 so rn must equal k + 1 everywhere
--         expected: 40000 rows, sum rn 800020000, matched 40000
evaluate '[5] ROW_NUMBER() OVER (ORDER BY k) (SORT_ANALYTIC): serial reference';
select count(*) cnt, sum(rn) sum_rn, sum(case when rn = k + 1 then 1 else 0 end) matched
  from (select /*+ PARALLEL(1) */ k, row_number() over (order by k) rn from px_sort_t) d;

evaluate '[5] ROW_NUMBER() OVER (ORDER BY k) (SORT_ANALYTIC): parallel';
select count(*) cnt, sum(rn) sum_rn, sum(case when rn = k + 1 then 1 else 0 end) matched
  from (select k, row_number() over (order by k) rn from px_sort_t) d;

-- Case 6: SUM(v) OVER (PARTITION BY grp ORDER BY id): running sum inside each group
--         expected: 40000 rows, see NOTES for sum/max of the running sums
evaluate '[6] SUM(v) OVER (PARTITION BY grp ORDER BY id) running sum (SORT_ANALYTIC): serial reference';
select count(*) cnt, sum(cast(rs as bigint)) sum_rs, max(rs) max_rs, min(rs) min_rs
  from (select /*+ PARALLEL(1) */ grp, id, sum(v) over (partition by grp order by id) rs from px_sort_t) d;

evaluate '[6] SUM(v) OVER (PARTITION BY grp ORDER BY id) running sum (SORT_ANALYTIC): parallel';
select count(*) cnt, sum(cast(rs as bigint)) sum_rs, max(rs) max_rs, min(rs) min_rs
  from (select grp, id, sum(v) over (partition by grp order by id) rs from px_sort_t) d;

-- Case 7: DISTINCT + ORDER BY + LIMIT (no in-memory top-N for DISTINCT)
--         expected: 50 rows, grp 0..49 (sum 1225)
evaluate '[7] DISTINCT grp ORDER BY grp LIMIT 50: serial reference';
select count(*) cnt, sum(g) sum_g, min(g) min_g, max(g) max_g
  from (select /*+ PARALLEL(1) */ distinct grp g from px_sort_t order by grp limit 50) d;

evaluate '[7] DISTINCT grp ORDER BY grp LIMIT 50: parallel';
select count(*) cnt, sum(g) sum_g, min(g) min_g, max(g) max_g
  from (select distinct grp g from px_sort_t order by grp limit 50) d;

drop table px_sort_t;
