/**
 *  This test case verifies CBRD-26795: parallel sort extended to GROUP BY,
 *  ORDER BY ... LIMIT and analytic functions.
 *
 *  Before the change only a plain ORDER BY sort could run on parallel sort
 *  workers. The change (external_sort.c: sort_check_parallelism,
 *  sort_start_parallelism, sort_end_parallelism) adds three sort types
 *    SORT_GROUP_BY         - the sort of a GROUP BY that is not hash-eligible
 *                            (NO_HASH_AGGREGATE hint, or hash aggregation
 *                            abandoned at run time)
 *    SORT_ORDER_WITH_LIMIT - ORDER BY + LIMIT whose result is estimated above
 *                            the in-memory top-N buffer (sort_buffer_size, 2MB)
 *    SORT_ANALYTIC         - the sort that feeds an analytic (OVER) function
 *  and replaces the static page slicing by sector stealing (workers grab input
 *  sectors with an atomic fetch_add) and the level-based fan-in by an async
 *  2-way queue merge. A defect in the distribution or in the merge shows up as
 *  lost, duplicated or misordered tuples, so every query runs once with the
 *  PARALLEL(1) hint (a hint degree below 2 makes compute_parallel_degree return
 *  0 for the scan and for the sort, i.e. the serial reference) and once or more
 *  in parallel. The runs print order-independent checksums (count, sum, min,
 *  max) of the result, which must be identical. Where the order of the rows is
 *  part of the check, each row is weighted by its ROWNUM.
 *
 *  The parallel runs use the default degree. Cases 1, 3 and 5 also run with
 *  PARALLEL(2) and PARALLEL(8), the bounds of the degree range of the
 *  acceptance criteria (N = 2 to 8) and the hints of the attached scenarios.
 *  A hint degree is capped by the number of cores, and a GROUP BY or analytic
 *  sort asks for no more workers than its input list has pages.
 *
 *  Under test_mode (CTP) parallel_sort_page_threshold is 0, so a sort whose
 *  input list has at least 2 pages and more tuples than the degree (as many
 *  for GROUP BY and analytic) is a parallel-sort candidate on a host with 3 or
 *  more cores, ORDER BY ... LIMIT additionally needs at least 500 input tuples
 *  (MIN_TUPLES_FOR_PARALLEL_SORT).
 *  The filler columns x1 .. x8 and pad of px_sort_t keep the estimated
 *  ORDER BY ... LIMIT result above the 2MB top-N buffer so that the external
 *  sort with limit really runs instead of the in-memory top-N heap. The
 *  ORDER BY ... LIMIT queries reference every filler column and pad in the
 *  outer checksum: an unreferenced select-list item of the non-mergeable
 *  inline view is pruned by the rewriter (mq_remove_select_list_for_inline_view),
 *  which would shrink the sorted tuple and send the query to the top-N heap.
 *  count(distinct ...) catches a lost row paired with a duplicated one whose
 *  values happen to keep the sums unchanged.
 *
 *  Only Case 12, the last query of Case 13 and the last two queries of
 *  Case 14 print a trace. CTP masks the numbers in it, so the answer does not
 *  contain a worker count, but the "(parallel workers: N, ...)" lines of
 *  Case 12 and Case 14 appear only on a host with 3 or more cores. Every other
 *  query prints checksums only, which do not depend on the number of cores.
 *
 *  Not checked here:
 *    - the worker clamp of the GROUP BY and analytic sorts under a partial
 *      worker reservation (sort_check_parallelism, get_reserved_workers) needs
 *      a limited worker pool, so it is checked by cbrd_26930 (shell, checks
 *      5 and 6)
 *    - the speed-up per degree and the cleanup after a failed worker start
 *      of the acceptance criteria need timing and fault injection
 *
 *  Data:
 *    px_sort_t  - id = 1 .. 40000, grp = id mod 97 (97 groups of 412 or 413
 *                 rows), k = (id * 7919) mod 40000 (a permutation of
 *                 0 .. 39999, unique), v = id mod 1000
 *    px_key_t   - 20,000 rows: cat is a VARCHAR key of 200 values, nk is NULL
 *                 in every 13th row and id mod 50 otherwise, sk puts the
 *                 first 18,000 rows (90 percent) into one value, one is the
 *                 same in every row, v is NULL in every 17th row
 *    px_wide_t  - 1500 rows of a 17,920-byte body of SHA-2 digests, larger
 *                 than a 16K page
 *    px_ord_t   - 40,000 rows with k of px_sort_t also as BIGINT, DOUBLE and
 *                 CHAR, a DATE with ties, and nk that is NULL in every 11th row
 *    px_grp_t   - one row per grp of px_sort_t
 *    px_rnd_t   - 3 rows of 8,960 bytes of SHA-2 digests
 *    px_empty_t - no rows
 *
 *  Coverage:
 *    Case 1:  GROUP BY + HAVING on the sort path (NO_HASH_AGGREGATE), also
 *             with PARALLEL(2) and PARALLEL(8)
 *    Case 2:  GROUP BY on the all-unique key k: hash aggregation is abandoned
 *             after 2,000 tuples and the partial list is sorted (SORT_GROUP_BY).
 *             Run three times: serial reference, NO_PARALLEL_SCAN (the leader
 *             abandons the hash itself) and the default degree (a parallel
 *             heap scan aggregates in the hash contexts of the workers)
 *    Case 3:  ORDER BY k, id LIMIT 32000 on the unique key, also with
 *             PARALLEL(2) and PARALLEL(8)
 *    Case 4:  ORDER BY grp, id LIMIT 32000 on a key with ties, id as tiebreak
 *    Case 5:  ROW_NUMBER() OVER (ORDER BY k), also with PARALLEL(2) and
 *             PARALLEL(8)
 *    Case 6:  SUM(v) OVER (PARTITION BY grp ORDER BY id) running sum
 *    Case 7:  DISTINCT grp ORDER BY grp LIMIT 50
 *    Case 8:  the analytic functions listed in the acceptance criteria in one
 *             query (three window specs, three analytic sorts)
 *    Case 9:  GROUP BY scenarios of the attached group_by script - NULL key,
 *             expression keys with every aggregate and DISTINCT aggregates,
 *             VARCHAR key after a WHERE filter, skewed key, single group,
 *             GROUP BY followed by ORDER BY, WITH ROLLUP, HASH_AGGREGATE,
 *             overflow tuples
 *    Case 10: analytic scenarios of the attached SORT_ANALYTIC script -
 *             expression partition keys, VARCHAR partition key, NULL partition
 *             and ordering values, skewed partition, one row per partition,
 *             analytic followed by ORDER BY, overflow tuples
 *    Case 11: ORDER BY ... LIMIT scenarios of the attached order_with_limit
 *             script - DESC, LIMIT equal to the row count, VARCHAR key, NULL key
 *    Case 12: SET TRACE ON prints a parallel worker line under GROUPBY,
 *             ANALYTIC and ORDERBY (NO_PARALLEL_SCAN keeps the scans serial,
 *             so only the sort lines carry a worker line), and no worker
 *             line under the GROUPBY line of a GROUP BY with HASH_AGGREGATE,
 *             whose hash table keeps every group and leaves no page to sort
 *    Case 13: empty input - the GROUP BY, analytic and ORDER BY ... LIMIT
 *             sorts stay serial and return no rows, and the trace of the
 *             analytic sort has no worker line (Case 12 is its positive
 *             control). ORDER BY ... LIMIT 0 returns no rows
 *    Case 14: plain ORDER BY (SORT_ORDER_BY), the acceptance criteria of
 *             CBRD-26765, which was resolved within CBRD-26795 - INT, BIGINT,
 *             DOUBLE, DATE and CHAR keys, MOD and CASE WHEN expressions, a join,
 *             DISTINCT, NULL keys, overflow tuples, an empty table, a repeated
 *             run, and a sort with no more rows than its degree that stays
 *             serial next to one with one more row that runs in parallel.
 *             The VARCHAR key and the worker line of a plain ORDER BY are
 *             checked by cbrd_25728 (shell)
 */

drop table if exists px_sort_t;

-- 40,000 rows of about 200 bytes: about 580 heap pages, past the parallel heap scan threshold of 32 pages under CTP,
-- and an ORDER BY ... LIMIT 32000 result estimate of 88 bytes x 32,000 rows, above the 2MB top-N buffer
create table px_sort_t (id int, grp int, k int, v int,
                        x1 bigint, x2 bigint, x3 bigint, x4 bigint,
                        x5 bigint, x6 bigint, x7 bigint, x8 bigint,
                        pad char(100));

insert into px_sort_t
  select rownum, mod(rownum, 97), mod(rownum * 7919, 40000), mod(rownum, 1000),
         rownum, rownum, rownum, rownum, rownum, rownum, rownum, rownum,
         lpad('x', 100, 'x')
  from db_class a, db_class b, db_class c, db_class d limit 40000;

drop table if exists px_key_t;
-- 20,000 rows of about 48 bytes: about 85 heap pages, past the parallel heap scan threshold of 32 pages under CTP,
-- and each sort input list of Case 9 and Case 10 on px_key_t has more pages than the default degree of 4,
-- so that the GROUP BY and analytic sorts on it run in parallel
create table px_key_t (id int, cat varchar(20), nk int, sk int, one int, v int);
insert into px_key_t
  select rownum, 'cat_' || lpad(mod(rownum, 200), 5, '0'),
         case when mod(rownum, 13) = 0 then null else mod(rownum, 50) end,
         case when rownum <= 18000 then 1 else mod(rownum, 100) end,
         42,
         case when mod(rownum, 17) = 0 then null else mod(rownum * 7, 1000) end
  from db_class a, db_class b, db_class c limit 20000;

drop table if exists px_hex_t;
-- 1,500 rows of 70 SHA-2 digests (8,960 bytes), which string compression does not shrink, the source of px_wide_t and px_rnd_t.
-- A repeated string such as lpad('a', 18000, 'x') is compressed to about 100 bytes and would never overflow a page.
create table px_hex_t (id int, h varchar(9000));
insert into px_hex_t
  select rownum, sha2(rownum * 100 + 1, 512) || sha2(rownum * 100 + 2, 512) || sha2(rownum * 100 + 3, 512) || sha2(rownum * 100 + 4, 512) || sha2(rownum * 100 + 5, 512) || sha2(rownum * 100 + 6, 512) || sha2(rownum * 100 + 7, 512) || sha2(rownum * 100 + 8, 512) || sha2(rownum * 100 + 9, 512) || sha2(rownum * 100 + 10, 512) || sha2(rownum * 100 + 11, 512) || sha2(rownum * 100 + 12, 512) || sha2(rownum * 100 + 13, 512) || sha2(rownum * 100 + 14, 512) || sha2(rownum * 100 + 15, 512) || sha2(rownum * 100 + 16, 512) || sha2(rownum * 100 + 17, 512) || sha2(rownum * 100 + 18, 512) || sha2(rownum * 100 + 19, 512) || sha2(rownum * 100 + 20, 512) || sha2(rownum * 100 + 21, 512) || sha2(rownum * 100 + 22, 512) || sha2(rownum * 100 + 23, 512) || sha2(rownum * 100 + 24, 512) || sha2(rownum * 100 + 25, 512) || sha2(rownum * 100 + 26, 512) || sha2(rownum * 100 + 27, 512) || sha2(rownum * 100 + 28, 512) || sha2(rownum * 100 + 29, 512) || sha2(rownum * 100 + 30, 512) || sha2(rownum * 100 + 31, 512) || sha2(rownum * 100 + 32, 512) || sha2(rownum * 100 + 33, 512) || sha2(rownum * 100 + 34, 512) || sha2(rownum * 100 + 35, 512) || sha2(rownum * 100 + 36, 512) || sha2(rownum * 100 + 37, 512) || sha2(rownum * 100 + 38, 512) || sha2(rownum * 100 + 39, 512) || sha2(rownum * 100 + 40, 512) || sha2(rownum * 100 + 41, 512) || sha2(rownum * 100 + 42, 512) || sha2(rownum * 100 + 43, 512) || sha2(rownum * 100 + 44, 512) || sha2(rownum * 100 + 45, 512) || sha2(rownum * 100 + 46, 512) || sha2(rownum * 100 + 47, 512) || sha2(rownum * 100 + 48, 512) || sha2(rownum * 100 + 49, 512) || sha2(rownum * 100 + 50, 512) || sha2(rownum * 100 + 51, 512) || sha2(rownum * 100 + 52, 512) || sha2(rownum * 100 + 53, 512) || sha2(rownum * 100 + 54, 512) || sha2(rownum * 100 + 55, 512) || sha2(rownum * 100 + 56, 512) || sha2(rownum * 100 + 57, 512) || sha2(rownum * 100 + 58, 512) || sha2(rownum * 100 + 59, 512) || sha2(rownum * 100 + 60, 512) || sha2(rownum * 100 + 61, 512) || sha2(rownum * 100 + 62, 512) || sha2(rownum * 100 + 63, 512) || sha2(rownum * 100 + 64, 512) || sha2(rownum * 100 + 65, 512) || sha2(rownum * 100 + 66, 512) || sha2(rownum * 100 + 67, 512) || sha2(rownum * 100 + 68, 512) || sha2(rownum * 100 + 69, 512) || sha2(rownum * 100 + 70, 512)
  from db_class a, db_class b, db_class c limit 1500;

drop table if exists px_wide_t;
-- 1,500 rows of a 17,920-byte body: about 3,000 heap pages, and every row is larger than a 16K page,
-- so the sort tuples of Case 9, Case 10 and Case 14 that carry body are overflow tuples
create table px_wide_t (id int, grp int, body varchar(20000));
insert into px_wide_t
  select id, mod(id, 50), h || reverse(h) from px_hex_t;

drop table if exists px_rnd_t;
-- 3 rows of 8,960 bytes, so that each row fills one sort input page, see Case 14
create table px_rnd_t (id int, body varchar(12000));
insert into px_rnd_t
  select id, h from px_hex_t where id <= 3;

drop table px_hex_t;

drop table if exists px_ord_t;
-- 40,000 rows of about 60 bytes: about 200 heap pages, past the parallel heap scan threshold of 32 pages under CTP.
-- k as in px_sort_t and the same order in BIGINT, DOUBLE and CHAR, dt with ties, nk NULL in every 11th row
create table px_ord_t (id int, k int, ib bigint, d double, dt date, c char(10), nk int);
insert into px_ord_t
  select rownum, mod(rownum * 7919, 40000), cast(mod(rownum * 7919, 40000) as bigint) * 100000, mod(rownum * 7919, 40000) / 7.0,
         date'2000-01-01' + mod(rownum * 37, 9000), lpad(mod(rownum * 7919, 40000), 10, '0'),
         case when mod(rownum, 11) = 0 then null else mod(rownum, 300) end
  from db_class a, db_class b, db_class c, db_class d limit 40000;

drop table if exists px_grp_t;
-- one row per grp of px_sort_t, gname sorts in another order than grp
create table px_grp_t (grp int, gname varchar(20));
insert into px_grp_t
  select rownum - 1, 'g_' || lpad(mod((rownum - 1) * 37, 97), 3, '0')
  from db_class a, db_class b limit 97;

drop table if exists px_empty_t;
create table px_empty_t (id int, grp int, k int, v int);

select count(*), count(distinct k), min(k), max(k), count(distinct grp) from px_sort_t;
select count(*), count(distinct cat), count(nk), count(distinct sk), count(v) from px_key_t;
select count(*), sum(length(body)) from px_wide_t;
select count(*), count(distinct k), count(nk), count(distinct dt) from px_ord_t;
select count(*), count(distinct gname) from px_grp_t;
select count(*), min(length(body)), max(length(body)) from px_rnd_t;

evaluate 'Case 1: GROUP BY + HAVING, sort path (NO_HASH_AGGREGATE) - serial reference; result = 36 groups, 14868 rows, grp 1..36';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k, min(g) min_grp, max(g) max_grp
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp having count(*) > 412) d;

evaluate 'Case 1: GROUP BY + HAVING, sort path (NO_HASH_AGGREGATE) - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k, min(g) min_grp, max(g) max_grp
  from (select /*+ NO_HASH_AGGREGATE */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp having count(*) > 412) d;

evaluate 'Case 1: GROUP BY + HAVING, sort path (NO_HASH_AGGREGATE) - PARALLEL(2), lower bound of the degree range; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k, min(g) min_grp, max(g) max_grp
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(2) */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp having count(*) > 412) d;

evaluate 'Case 1: GROUP BY + HAVING, sort path (NO_HASH_AGGREGATE) - PARALLEL(8), upper bound of the degree range; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k, min(g) min_grp, max(g) max_grp
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(8) */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp having count(*) > 412) d;

-- k is unique, so the hash aggregation is abandoned after 2,000 tuples and the partial list is sorted
evaluate 'Case 2: GROUP BY on an all-unique key (hash abandoned -> SORT_GROUP_BY) - serial reference; result = 40000 groups, 40000 rows';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select /*+ PARALLEL(1) */ k kk, count(*) cnt, sum(v) sv from px_sort_t group by k having count(*) = 1) d;

evaluate 'Case 2: GROUP BY on an all-unique key (hash abandoned -> SORT_GROUP_BY) - parallel sort (NO_PARALLEL_SCAN); result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select /*+ NO_PARALLEL_SCAN */ k kk, count(*) cnt, sum(v) sv from px_sort_t group by k having count(*) = 1) d;

evaluate 'Case 2: GROUP BY on an all-unique key (hash abandoned in the scan workers) - parallel scan; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select k kk, count(*) cnt, sum(v) sv from px_sort_t group by k having count(*) = 1) d;

-- the filler columns keep the result estimate above the 2MB top-N buffer, see the header
evaluate 'Case 3: ORDER BY unique key LIMIT 32000 (SORT_ORDER_WITH_LIMIT) - serial reference; result = 32000 rows, k 0..31999, sum_x = 8 x sum_id';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(1) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 32000) d;

evaluate 'Case 3: ORDER BY unique key LIMIT 32000 (SORT_ORDER_WITH_LIMIT) - parallel; result = same as serial';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 32000) d;

evaluate 'Case 3: ORDER BY unique key LIMIT 32000 (SORT_ORDER_WITH_LIMIT) - PARALLEL(2), lower bound of the degree range; result = same as serial';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(2) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 32000) d;

evaluate 'Case 3: ORDER BY unique key LIMIT 32000 (SORT_ORDER_WITH_LIMIT) - PARALLEL(8), upper bound of the degree range; result = same as serial';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(8) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 32000) d;

-- grp has ties (412 or 413 rows per value), id breaks them
evaluate 'Case 4: ORDER BY key with ties + id tiebreak, LIMIT 32000 - serial reference; result = 32000 rows, grp 0..77, 240 rows of grp 77 up to id 23260';
select count(*) cnt, count(distinct id) dist_id, sum(grp) sum_grp, max(grp) max_grp, sum(id) sum_id, sum(k) sum_k,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad,
       sum(case when grp = 77 then 1 else 0 end) rows_in_last_grp, max(case when grp = 77 then id else 0 end) max_id_in_last_grp
  from (select /*+ PARALLEL(1) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by grp, id limit 32000) d;

evaluate 'Case 4: ORDER BY key with ties + id tiebreak, LIMIT 32000 - parallel; result = same as serial';
select count(*) cnt, count(distinct id) dist_id, sum(grp) sum_grp, max(grp) max_grp, sum(id) sum_id, sum(k) sum_k,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad,
       sum(case when grp = 77 then 1 else 0 end) rows_in_last_grp, max(case when grp = 77 then id else 0 end) max_id_in_last_grp
  from (select id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by grp, id limit 32000) d;

-- k is a permutation of 0..39999, so matched counts the rows whose rn is k + 1
evaluate 'Case 5: ROW_NUMBER() OVER (ORDER BY k) (SORT_ANALYTIC) - serial reference; result = 40000 rows, all 40000 matched';
select count(*) cnt, sum(rn) sum_rn, sum(case when rn = k + 1 then 1 else 0 end) matched
  from (select /*+ PARALLEL(1) */ k, row_number() over (order by k) rn from px_sort_t) d;

evaluate 'Case 5: ROW_NUMBER() OVER (ORDER BY k) (SORT_ANALYTIC) - parallel; result = same as serial';
select count(*) cnt, sum(rn) sum_rn, sum(case when rn = k + 1 then 1 else 0 end) matched
  from (select k, row_number() over (order by k) rn from px_sort_t) d;

evaluate 'Case 5: ROW_NUMBER() OVER (ORDER BY k) (SORT_ANALYTIC) - PARALLEL(2), lower bound of the degree range; result = same as serial';
select count(*) cnt, sum(rn) sum_rn, sum(case when rn = k + 1 then 1 else 0 end) matched
  from (select /*+ PARALLEL(2) */ k, row_number() over (order by k) rn from px_sort_t) d;

evaluate 'Case 5: ROW_NUMBER() OVER (ORDER BY k) (SORT_ANALYTIC) - PARALLEL(8), upper bound of the degree range; result = same as serial';
select count(*) cnt, sum(rn) sum_rn, sum(case when rn = k + 1 then 1 else 0 end) matched
  from (select /*+ PARALLEL(8) */ k, row_number() over (order by k) rn from px_sort_t) d;

evaluate 'Case 6: SUM(v) OVER (PARTITION BY grp ORDER BY id) running sum (SORT_ANALYTIC) - serial reference';
select count(*) cnt, sum(cast(rs as bigint)) sum_rs, max(rs) max_rs, min(rs) min_rs
  from (select /*+ PARALLEL(1) */ grp, id, sum(v) over (partition by grp order by id) rs from px_sort_t) d;

evaluate 'Case 6: SUM(v) OVER (PARTITION BY grp ORDER BY id) running sum (SORT_ANALYTIC) - parallel; result = same as serial';
select count(*) cnt, sum(cast(rs as bigint)) sum_rs, max(rs) max_rs, min(rs) min_rs
  from (select grp, id, sum(v) over (partition by grp order by id) rs from px_sort_t) d;

-- DISTINCT has no in-memory top-N, so the sort with limit runs
evaluate 'Case 7: DISTINCT grp ORDER BY grp LIMIT 50 - serial reference; result = 50 rows, grp 0..49';
select count(*) cnt, sum(g) sum_g, min(g) min_g, max(g) max_g
  from (select /*+ PARALLEL(1) */ distinct grp g from px_sort_t order by grp limit 50) d;

evaluate 'Case 7: DISTINCT grp ORDER BY grp LIMIT 50 - parallel; result = same as serial';
select count(*) cnt, sum(g) sum_g, min(g) min_g, max(g) max_g
  from (select distinct grp g from px_sort_t order by grp limit 50) d;

-- the analytic functions of the acceptance criteria in one query.
-- The three window specs (grp/v desc, grp/id, grp/v) give three analytic sorts.
-- Every value is reduced to a bigint sum, and the floating point ones are rounded per row first.
evaluate 'Case 8: analytic functions (RANK ... VARIANCE) over three window specs - serial reference';
select count(*) cnt, sum(cast(rk as bigint)) s_rank, sum(cast(dr as bigint)) s_dense_rank, sum(cast(nt as bigint)) s_ntile,
       sum(cast(lg as bigint)) s_lag, sum(cast(ld as bigint)) s_lead, sum(cast(fv as bigint)) s_first, sum(cast(lv as bigint)) s_last,
       sum(cast(c as bigint)) s_count, sum(cast(mn as bigint)) s_min, sum(cast(mx as bigint)) s_max, sum(cast(sm as bigint)) s_sum,
       sum(cast(round(av, 3) * 1000 as bigint)) s_avg, sum(cast(round(cd, 6) * 1000000 as bigint)) s_cume_dist,
       sum(cast(round(pr, 6) * 1000000 as bigint)) s_percent_rank, sum(cast(md * 10 as bigint)) s_median,
       sum(cast(round(sd, 3) * 1000 as bigint)) s_stddev, sum(cast(round(vr, 3) * 1000 as bigint)) s_variance
  from (select /*+ PARALLEL(1) */
               rank() over (partition by grp order by v desc) rk,
               dense_rank() over (partition by grp order by v desc) dr,
               ntile(7) over (partition by grp order by id) nt,
               lag(v, 2, -1) over (partition by grp order by id) lg,
               lead(v, 1, -1) over (partition by grp order by id) ld,
               first_value(v) over (partition by grp order by id) fv,
               last_value(v) over (partition by grp order by id) lv,
               count(*) over (partition by grp) c,
               min(v) over (partition by grp) mn,
               max(v) over (partition by grp) mx,
               sum(v) over (partition by grp order by id) sm,
               avg(v) over (partition by grp) av,
               cume_dist() over (partition by grp order by v) cd,
               percent_rank() over (partition by grp order by v) pr,
               median(v) over (partition by grp) md,
               stddev(v) over (partition by grp) sd,
               variance(v) over (partition by grp) vr
          from px_sort_t) d;

evaluate 'Case 8: analytic functions (RANK ... VARIANCE) over three window specs - parallel; result = same as serial';
select count(*) cnt, sum(cast(rk as bigint)) s_rank, sum(cast(dr as bigint)) s_dense_rank, sum(cast(nt as bigint)) s_ntile,
       sum(cast(lg as bigint)) s_lag, sum(cast(ld as bigint)) s_lead, sum(cast(fv as bigint)) s_first, sum(cast(lv as bigint)) s_last,
       sum(cast(c as bigint)) s_count, sum(cast(mn as bigint)) s_min, sum(cast(mx as bigint)) s_max, sum(cast(sm as bigint)) s_sum,
       sum(cast(round(av, 3) * 1000 as bigint)) s_avg, sum(cast(round(cd, 6) * 1000000 as bigint)) s_cume_dist,
       sum(cast(round(pr, 6) * 1000000 as bigint)) s_percent_rank, sum(cast(md * 10 as bigint)) s_median,
       sum(cast(round(sd, 3) * 1000 as bigint)) s_stddev, sum(cast(round(vr, 3) * 1000 as bigint)) s_variance
  from (select rank() over (partition by grp order by v desc) rk,
               dense_rank() over (partition by grp order by v desc) dr,
               ntile(7) over (partition by grp order by id) nt,
               lag(v, 2, -1) over (partition by grp order by id) lg,
               lead(v, 1, -1) over (partition by grp order by id) ld,
               first_value(v) over (partition by grp order by id) fv,
               last_value(v) over (partition by grp order by id) lv,
               count(*) over (partition by grp) c,
               min(v) over (partition by grp) mn,
               max(v) over (partition by grp) mx,
               sum(v) over (partition by grp order by id) sm,
               avg(v) over (partition by grp) av,
               cume_dist() over (partition by grp order by v) cd,
               percent_rank() over (partition by grp order by v) pr,
               median(v) over (partition by grp) md,
               stddev(v) over (partition by grp) sd,
               variance(v) over (partition by grp) vr
          from px_sort_t) d;

-- Case 9 follows the GROUP BY scenarios of the attached group_by script, each on the sort path (NO_HASH_AGGREGATE)
evaluate 'Case 9: GROUP BY a key with NULLs, NULL values in the aggregates - serial reference; result = 51 groups, 50 non-NULL keys';
select count(*) grp_cnt, count(g) non_null_grp, sum(cnt) row_cnt, sum(cv) non_null_v, sum(sv) sum_v, sum(case when g is null then cnt else 0 end) null_grp_rows
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ nk g, count(*) cnt, count(v) cv, sum(v) sv
          from px_key_t group by nk) d;

evaluate 'Case 9: GROUP BY a key with NULLs, NULL values in the aggregates - parallel; result = same as serial';
select count(*) grp_cnt, count(g) non_null_grp, sum(cnt) row_cnt, sum(cv) non_null_v, sum(sv) sum_v, sum(case when g is null then cnt else 0 end) null_grp_rows
  from (select /*+ NO_HASH_AGGREGATE */ nk g, count(*) cnt, count(v) cv, sum(v) sv
          from px_key_t group by nk) d;

-- id mod 10 and grp mod 50 are independent (grp = id mod 97), so neither key decides the other.
-- The floating point aggregates are rounded per group before they are summed.
evaluate 'Case 9: GROUP BY expression keys with every aggregate type and DISTINCT aggregates - serial reference; result = 500 groups, 40000 rows';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(cast(round(av, 3) * 1000 as bigint)) s_avg, sum(mn) sum_min_k, sum(mx) sum_max_k,
       sum(cast(round(sd, 3) * 1000 as bigint)) s_stddev, sum(cast(round(vr, 3) * 1000 as bigint)) s_variance, sum(cd) sum_cnt_dist, sum(sd2) sum_sum_dist
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ mod(id, 10) a, mod(grp, 50) b, count(*) cnt, sum(v) sv, avg(v) av, min(k) mn, max(k) mx,
               stddev(v) sd, variance(v) vr, count(distinct grp) cd, sum(distinct grp) sd2
          from px_sort_t group by mod(id, 10), mod(grp, 50)) d;

evaluate 'Case 9: GROUP BY expression keys with every aggregate type and DISTINCT aggregates - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(cast(round(av, 3) * 1000 as bigint)) s_avg, sum(mn) sum_min_k, sum(mx) sum_max_k,
       sum(cast(round(sd, 3) * 1000 as bigint)) s_stddev, sum(cast(round(vr, 3) * 1000 as bigint)) s_variance, sum(cd) sum_cnt_dist, sum(sd2) sum_sum_dist
  from (select /*+ NO_HASH_AGGREGATE */ mod(id, 10) a, mod(grp, 50) b, count(*) cnt, sum(v) sv, avg(v) av, min(k) mn, max(k) mx,
               stddev(v) sd, variance(v) vr, count(distinct grp) cd, sum(distinct grp) sd2
          from px_sort_t group by mod(id, 10), mod(grp, 50)) d;

evaluate 'Case 9: GROUP BY a VARCHAR key after a WHERE filter - serial reference; result = 200 groups';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, min(c) min_cat, max(c) max_cat, sum(mn) sum_min_v, sum(mx) sum_max_v
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ cat c, count(*) cnt, sum(v) sv, min(v) mn, max(v) mx
          from px_key_t where v > 500 group by cat) d;

evaluate 'Case 9: GROUP BY a VARCHAR key after a WHERE filter - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, min(c) min_cat, max(c) max_cat, sum(mn) sum_min_v, sum(mx) sum_max_v
  from (select /*+ NO_HASH_AGGREGATE */ cat c, count(*) cnt, sum(v) sv, min(v) mn, max(v) mx
          from px_key_t where v > 500 group by cat) d;

evaluate 'Case 9: GROUP BY a skewed key, 90 percent of the rows in one group - serial reference; result = 100 groups, largest 18020 rows';
select count(*) grp_cnt, sum(cnt) row_cnt, max(cnt) max_cnt, sum(sv) sum_v
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ sk g, count(*) cnt, sum(v) sv
          from px_key_t group by sk) d;

evaluate 'Case 9: GROUP BY a skewed key, 90 percent of the rows in one group - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, max(cnt) max_cnt, sum(sv) sum_v
  from (select /*+ NO_HASH_AGGREGATE */ sk g, count(*) cnt, sum(v) sv
          from px_key_t group by sk) d;

evaluate 'Case 9: GROUP BY a key with one value - serial reference; result = 1 group, 20000 rows';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, min(mn) min_v, max(mx) max_v
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ one g, count(*) cnt, sum(v) sv, min(v) mn, max(v) mx
          from px_key_t group by one) d;

evaluate 'Case 9: GROUP BY a key with one value - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, min(mn) min_v, max(mx) max_v
  from (select /*+ NO_HASH_AGGREGATE */ one g, count(*) cnt, sum(v) sv, min(v) mn, max(v) mx
          from px_key_t group by one) d;

-- o is the position of each group after ORDER BY c DESC, grp, so ord_sum changes when the order changes.
-- NO_MERGE keeps the ORDER BY a sort of its own after the GROUP BY sort, see Case 14
evaluate 'Case 9: GROUP BY followed by ORDER BY - serial reference; result = 97 groups';
select count(*) grp_cnt, sum(cast(o as bigint) * g) ord_sum, sum(c) row_cnt
  from (select rownum o, g, c
          from (select /*+ NO_HASH_AGGREGATE NO_MERGE PARALLEL(1) */ grp g, count(*) c
                  from px_sort_t group by grp order by c desc, grp) s) d;

evaluate 'Case 9: GROUP BY followed by ORDER BY - parallel; result = same as serial';
select count(*) grp_cnt, sum(cast(o as bigint) * g) ord_sum, sum(c) row_cnt
  from (select rownum o, g, c
          from (select /*+ NO_HASH_AGGREGATE NO_MERGE */ grp g, count(*) c
                  from px_sort_t group by grp order by c desc, grp) s) d;

evaluate 'Case 9: GROUP BY ... WITH ROLLUP - serial reference; result = 970 detail + 97 subtotal + 1 total rows';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(case when s is null then 1 else 0 end) subtotal_rows,
       sum(case when g is null then 1 else 0 end) grand_total_rows
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ grp g, mod(v, 10) s, count(*) cnt, sum(v) sv
          from px_sort_t group by grp, mod(v, 10) with rollup) d;

evaluate 'Case 9: GROUP BY ... WITH ROLLUP - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(case when s is null then 1 else 0 end) subtotal_rows,
       sum(case when g is null then 1 else 0 end) grand_total_rows
  from (select /*+ NO_HASH_AGGREGATE */ grp g, mod(v, 10) s, count(*) cnt, sum(v) sv
          from px_sort_t group by grp, mod(v, 10) with rollup) d;

-- HASH_AGGREGATE keeps the hash aggregation planned, the sort-path queries of this case use NO_HASH_AGGREGATE
evaluate 'Case 9: GROUP BY with HASH_AGGREGATE - serial reference; result = 97 groups, 40000 rows';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k
  from (select /*+ HASH_AGGREGATE PARALLEL(1) */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp) d;

evaluate 'Case 9: GROUP BY with HASH_AGGREGATE - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(sv) sum_v, sum(mn) sum_min_k, sum(mx) sum_max_k
  from (select /*+ HASH_AGGREGATE */ grp g, count(*) cnt, sum(v) sv, min(k) mn, max(k) mx
          from px_sort_t group by grp) d;

-- max(body) puts the 17,920-byte body of px_wide_t into each tuple of the sort input, so every one is an overflow tuple
evaluate 'Case 9: GROUP BY over overflow tuples - serial reference; result = 50 groups, 1500 rows';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(mn) sum_min_id, sum(mx) sum_max_id, sum(length(mb)) sum_len
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ grp g, count(*) cnt, min(id) mn, max(id) mx, max(body) mb
          from px_wide_t group by grp) d;

evaluate 'Case 9: GROUP BY over overflow tuples - parallel; result = same as serial';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(mn) sum_min_id, sum(mx) sum_max_id, sum(length(mb)) sum_len
  from (select /*+ NO_HASH_AGGREGATE */ grp g, count(*) cnt, min(id) mn, max(id) mx, max(body) mb
          from px_wide_t group by grp) d;

-- Case 10 follows the analytic scenarios of the attached SORT_ANALYTIC script
-- id mod 10 and grp mod 50 are independent (grp = id mod 97), so neither key decides the other
evaluate 'Case 10: analytic with expression partition keys - serial reference; result = 40000 rows, 500 partitions';
select count(*) cnt, sum(case when rn = 1 then 1 else 0 end) parts, sum(cast(rn as bigint)) sum_rn, max(rn) max_rn
  from (select /*+ PARALLEL(1) */ row_number() over (partition by mod(id, 10), mod(grp, 50) order by id) rn from px_sort_t) d;

evaluate 'Case 10: analytic with expression partition keys - parallel; result = same as serial';
select count(*) cnt, sum(case when rn = 1 then 1 else 0 end) parts, sum(cast(rn as bigint)) sum_rn, max(rn) max_rn
  from (select row_number() over (partition by mod(id, 10), mod(grp, 50) order by id) rn from px_sort_t) d;

evaluate 'Case 10: analytic with a VARCHAR partition key - serial reference; result = 20000 rows';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, sum(cast(rs as bigint)) sum_rs
  from (select /*+ PARALLEL(1) */ row_number() over (partition by cat order by v, id) rn,
               sum(v) over (partition by cat order by v, id) rs
          from px_key_t) d;

evaluate 'Case 10: analytic with a VARCHAR partition key - parallel; result = same as serial';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, sum(cast(rs as bigint)) sum_rs
  from (select row_number() over (partition by cat order by v, id) rn,
               sum(v) over (partition by cat order by v, id) rs
          from px_key_t) d;

evaluate 'Case 10: analytic with NULL partition keys and NULL ordering values - serial reference; result = 20000 rows';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, sum(cast(lg as bigint)) sum_lag, count(lg) non_null_lag
  from (select /*+ PARALLEL(1) */ row_number() over (partition by nk order by v, id) rn,
               lag(v, 1) over (partition by nk order by v, id) lg
          from px_key_t) d;

evaluate 'Case 10: analytic with NULL partition keys and NULL ordering values - parallel; result = same as serial';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, sum(cast(lg as bigint)) sum_lag, count(lg) non_null_lag
  from (select row_number() over (partition by nk order by v, id) rn,
               lag(v, 1) over (partition by nk order by v, id) lg
          from px_key_t) d;

evaluate 'Case 10: analytic with a skewed partition, 90 percent of the rows in one - serial reference; result = 20000 rows, largest 18020';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, max(c) max_cnt
  from (select /*+ PARALLEL(1) */ row_number() over (partition by sk order by v, id) rn,
               count(*) over (partition by sk) c
          from px_key_t) d;

evaluate 'Case 10: analytic with a skewed partition, 90 percent of the rows in one - parallel; result = same as serial';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, max(c) max_cnt
  from (select row_number() over (partition by sk order by v, id) rn,
               count(*) over (partition by sk) c
          from px_key_t) d;

evaluate 'Case 10: analytic with one row per partition - serial reference; result = 40000 rows, every rn 1';
select count(*) cnt, sum(rn) sum_rn, max(rn) max_rn
  from (select /*+ PARALLEL(1) */ row_number() over (partition by id order by v) rn from px_sort_t) d;

evaluate 'Case 10: analytic with one row per partition - parallel; result = same as serial';
select count(*) cnt, sum(rn) sum_rn, max(rn) max_rn
  from (select row_number() over (partition by id order by v) rn from px_sort_t) d;

-- o is the position of each row after ORDER BY grp, v, id, so ord_sum changes when the order changes.
-- NO_MERGE keeps the ORDER BY a sort of its own after the analytic sort, see Case 14
evaluate 'Case 10: analytic followed by ORDER BY - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * rn) ord_sum
  from (select rownum o, rn
          from (select /*+ NO_MERGE PARALLEL(1) */ row_number() over (partition by grp order by v, id) rn
                  from px_sort_t order by grp, v, id) s) d;

evaluate 'Case 10: analytic followed by ORDER BY - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * rn) ord_sum
  from (select rownum o, rn
          from (select /*+ NO_MERGE */ row_number() over (partition by grp order by v, id) rn
                  from px_sort_t order by grp, v, id) s) d;

-- each tuple of the sort input carries the 17,920-byte body of px_wide_t, an overflow tuple
evaluate 'Case 10: analytic sort of overflow tuples - serial reference; result = 1500 rows, sum rn 23250';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, sum(length(fb)) sum_first_len, sum(cast(lb as bigint)) sum_len
  from (select /*+ PARALLEL(1) */ row_number() over (partition by grp order by id) rn,
               first_value(body) over (partition by grp order by id) fb, length(body) lb
          from px_wide_t) d;

evaluate 'Case 10: analytic sort of overflow tuples - parallel; result = same as serial';
select count(*) cnt, sum(cast(rn as bigint)) sum_rn, sum(length(fb)) sum_first_len, sum(cast(lb as bigint)) sum_len
  from (select row_number() over (partition by grp order by id) rn,
               first_value(body) over (partition by grp order by id) fb, length(body) lb
          from px_wide_t) d;

-- Case 11 follows the scenarios of the attached order_with_limit script, the filler columns keep each result above the top-N buffer
evaluate 'Case 11: ORDER BY DESC LIMIT 32000 - serial reference; result = 32000 rows, k 8000..39999';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(1) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k desc, id limit 32000) d;

evaluate 'Case 11: ORDER BY DESC LIMIT 32000 - parallel; result = same as serial';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k desc, id limit 32000) d;

evaluate 'Case 11: ORDER BY with LIMIT equal to the row count - serial reference; result = 40000 rows';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(1) */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 40000) d;

evaluate 'Case 11: ORDER BY with LIMIT equal to the row count - parallel; result = same as serial';
select count(*) cnt, count(distinct k) dist_k, sum(k) sum_k, min(k) min_k, max(k) max_k, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 40000) d;

evaluate 'Case 11: ORDER BY a VARCHAR key LIMIT 32000 - serial reference; result = 32000 rows';
select count(*) cnt, count(distinct ck) dist_ck, min(ck) min_ck, max(ck) max_ck, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(1) */ id, grp, k, v, cast(k as varchar(10)) ck, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by ck, id limit 32000) d;

evaluate 'Case 11: ORDER BY a VARCHAR key LIMIT 32000 - parallel; result = same as serial';
select count(*) cnt, count(distinct ck) dist_ck, min(ck) min_ck, max(ck) max_ck, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select id, grp, k, v, cast(k as varchar(10)) ck, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by ck, id limit 32000) d;

-- nv is NULL in every 5th row, NULLs sort first in ascending order
evaluate 'Case 11: ORDER BY a key with NULLs LIMIT 32000 - serial reference; result = 32000 rows, 8000 NULL keys';
select count(*) cnt, count(nv) non_null_nv, sum(nv) sum_nv, max(nv) max_nv, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ PARALLEL(1) */ id, grp, k, v, case when mod(id, 5) = 0 then null else v end nv,
               x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by nv, id limit 32000) d;

evaluate 'Case 11: ORDER BY a key with NULLs LIMIT 32000 - parallel; result = same as serial';
select count(*) cnt, count(nv) non_null_nv, sum(nv) sum_nv, max(nv) max_nv, sum(id) sum_id,
       sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select id, grp, k, v, case when mod(id, 5) = 0 then null else v end nv,
               x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by nv, id limit 32000) d;

-- NO_PARALLEL_SCAN on both query levels keeps the scans serial, so the only
-- "(parallel workers: ...)" line of each trace is the one under the sort.
set trace on;

evaluate 'Case 12: trace - GROUPBY of a sort-based GROUP BY has a parallel worker line';
select /*+ NO_PARALLEL_SCAN */ count(*) grp_cnt, sum(cnt) row_cnt
  from (select /*+ NO_HASH_AGGREGATE NO_PARALLEL_SCAN */ grp g, count(*) cnt from px_sort_t group by grp) d;
show trace;

evaluate 'Case 12: trace - ANALYTIC has a parallel worker line';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(rn) sum_rn
  from (select /*+ NO_PARALLEL_SCAN */ k, row_number() over (order by k) rn from px_sort_t) d;
show trace;

evaluate 'Case 12: trace - ORDERBY of ORDER BY ... LIMIT above the top-N buffer has a parallel worker line';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8) sum_x, sum(length(pad)) sum_pad
  from (select /*+ NO_PARALLEL_SCAN */ id, grp, k, v, x1, x2, x3, x4, x5, x6, x7, x8, pad
          from px_sort_t order by k, id limit 32000) d;
show trace;

-- The attached scenario expects no parallel worker line under the GROUPBY line of a GROUP BY with HASH_AGGREGATE,
-- because the change kept a hash-eligible GROUP BY out of the parallel sort. CBRD-27727 later dropped that rule.
-- The line stays absent because the hash table keeps every group of grp and leaves no page to sort.
evaluate 'Case 12: trace - GROUPBY of a GROUP BY with HASH_AGGREGATE keeps the hash and has no parallel worker line';
select /*+ NO_PARALLEL_SCAN */ count(*) grp_cnt, sum(cnt) row_cnt
  from (select /*+ HASH_AGGREGATE NO_PARALLEL_SCAN */ grp g, count(*) cnt from px_sort_t group by grp) d;
show trace;

set trace off;

-- an empty sort input has fewer pages than the parallel sort threshold (at least 2), so every sort stays serial
evaluate 'Case 13: empty input - GROUP BY (NO_HASH_AGGREGATE); result = 0 groups';
select count(*) grp_cnt, sum(cnt) row_cnt
  from (select /*+ NO_HASH_AGGREGATE */ grp, count(*) cnt from px_empty_t group by grp) d;

evaluate 'Case 13: empty input after a filter - GROUP BY (NO_HASH_AGGREGATE); result = 0 groups';
select count(*) grp_cnt, sum(cnt) row_cnt
  from (select /*+ NO_HASH_AGGREGATE */ grp, count(*) cnt from px_sort_t where v < 0 group by grp) d;

evaluate 'Case 13: empty input - ORDER BY ... LIMIT; result = 0 rows';
select count(*) cnt
  from (select id from px_empty_t order by k, id limit 32000) d;

evaluate 'Case 13: ORDER BY ... LIMIT 0; result = 0 rows';
select count(*) cnt
  from (select id, x1 from px_sort_t order by k, id limit 0) d;

set trace on;

evaluate 'Case 13: empty input - analytic sort stays serial (no parallel worker line under ANALYTIC); result = 0 rows';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(cast(rn as bigint)) sum_rn
  from (select /*+ NO_PARALLEL_SCAN */ row_number() over (partition by grp order by id) rn from px_empty_t) d;
show trace;

set trace off;

-- Case 14 follows the acceptance criteria of CBRD-26765, which was resolved within CBRD-26795: a plain ORDER BY (SORT_ORDER_BY)
-- reads its input through the sector scan of the change. NO_MERGE keeps each ordered inline view as it is: without it the
-- rewriter merges the outer ROWNUM into the view as ORDERBY_NUM(), which turns the sort into an ORDER BY ... LIMIT sort.
-- o is the position of each row after the ORDER BY, so ord_sum changes when the order changes.
evaluate 'Case 14: plain ORDER BY an INT key - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE PARALLEL(1) */ id, k from px_ord_t order by k) s) d;

evaluate 'Case 14: plain ORDER BY an INT key - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE */ id, k from px_ord_t order by k) s) d;

-- the same query once more: the parallel sort reserves and releases its workers again
evaluate 'Case 14: plain ORDER BY an INT key - parallel, run again; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE */ id, k from px_ord_t order by k) s) d;

evaluate 'Case 14: plain ORDER BY a BIGINT key - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE PARALLEL(1) */ id, ib from px_ord_t order by ib) s) d;

evaluate 'Case 14: plain ORDER BY a BIGINT key - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE */ id, ib from px_ord_t order by ib) s) d;

evaluate 'Case 14: plain ORDER BY a DOUBLE key - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE PARALLEL(1) */ id, d from px_ord_t order by d) s) d;

evaluate 'Case 14: plain ORDER BY a DOUBLE key - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE */ id, d from px_ord_t order by d) s) d;

evaluate 'Case 14: plain ORDER BY a DATE key with ties - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE PARALLEL(1) */ id, dt from px_ord_t order by dt, id) s) d;

evaluate 'Case 14: plain ORDER BY a DATE key with ties - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE */ id, dt from px_ord_t order by dt, id) s) d;

evaluate 'Case 14: plain ORDER BY a CHAR key - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE PARALLEL(1) */ id, c from px_ord_t order by c) s) d;

evaluate 'Case 14: plain ORDER BY a CHAR key - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE */ id, c from px_ord_t order by c) s) d;

evaluate 'Case 14: plain ORDER BY MOD and CASE WHEN expressions - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id
          from (select /*+ NO_MERGE PARALLEL(1) */ id, k from px_ord_t
                 order by mod(k, 97), case when mod(id, 3) = 0 then k else -k end, id) s) d;

evaluate 'Case 14: plain ORDER BY MOD and CASE WHEN expressions - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id
          from (select /*+ NO_MERGE */ id, k from px_ord_t
                 order by mod(k, 97), case when mod(id, 3) = 0 then k else -k end, id) s) d;

-- px_grp_t has one row per grp of px_sort_t
evaluate 'Case 14: plain ORDER BY over a join - serial reference; result = 40000 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id
          from (select /*+ NO_MERGE PARALLEL(1) */ a.id, g.gname, a.k from px_sort_t a, px_grp_t g
                 where a.grp = g.grp order by g.gname, a.k) s) d;

evaluate 'Case 14: plain ORDER BY over a join - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id
          from (select /*+ NO_MERGE */ a.id, g.gname, a.k from px_sort_t a, px_grp_t g
                 where a.grp = g.grp order by g.gname, a.k) s) d;

evaluate 'Case 14: DISTINCT with ORDER BY - serial reference; result = 1000 rows';
select count(*) cnt, sum(cast(o as bigint) * dv) ord_sum
  from (select rownum o, dv from (select /*+ NO_MERGE PARALLEL(1) */ distinct v dv from px_sort_t order by v desc) s) d;

evaluate 'Case 14: DISTINCT with ORDER BY - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * dv) ord_sum
  from (select rownum o, dv from (select /*+ NO_MERGE */ distinct v dv from px_sort_t order by v desc) s) d;

-- nk is NULL in every 11th row, NULLs sort first in ascending order
evaluate 'Case 14: plain ORDER BY a key with NULLs - serial reference; result = 40000 rows, the 3636 NULL rows first (null_pos_sum = 1 + ... + 3636)';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum, sum(case when nk is null then o else 0 end) null_pos_sum
  from (select rownum o, id, nk from (select /*+ NO_MERGE PARALLEL(1) */ id, nk from px_ord_t order by nk, id) s) d;

evaluate 'Case 14: plain ORDER BY a key with NULLs - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum, sum(case when nk is null then o else 0 end) null_pos_sum
  from (select rownum o, id, nk from (select /*+ NO_MERGE */ id, nk from px_ord_t order by nk, id) s) d;

-- the outer query reads body, so each tuple of the sort input carries the 17,920-byte body of px_wide_t, an overflow tuple
evaluate 'Case 14: plain ORDER BY over overflow tuples - serial reference; result = 1500 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum, sum(length(body)) sum_len
  from (select rownum o, id, body from (select /*+ NO_MERGE PARALLEL(1) */ id, grp, body from px_wide_t order by grp desc, id) s) d;

evaluate 'Case 14: plain ORDER BY over overflow tuples - parallel; result = same as serial';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum, sum(length(body)) sum_len
  from (select rownum o, id, body from (select /*+ NO_MERGE */ id, grp, body from px_wide_t order by grp desc, id) s) d;

evaluate 'Case 14: plain ORDER BY an empty table; result = 0 rows';
select count(*) cnt, sum(cast(o as bigint) * id) ord_sum
  from (select rownum o, id from (select /*+ NO_MERGE */ id, k from px_empty_t order by k, id) s) d;

-- Each px_rnd_t row is one sort input page (8,960 bytes of SHA-2 digests, which string compression does not shrink).
-- The pair also shows that NO_MERGE took effect: an ORDER BY ... LIMIT sort of 3 rows would stay serial.
-- 2 rows give 2 pages and a computed degree of 2, and tuple_cnt <= degree keeps the sort serial (sort_check_parallelism).
-- 3 rows give 3 pages, the same degree, and more tuples than the degree, so that sort runs in parallel.
set trace on;

evaluate 'Case 14: trace - plain ORDER BY of 3 rows has a parallel worker line';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(cast(o as bigint) * id) ord_sum, sum(length(body)) sum_len
  from (select rownum o, id, body from (select /*+ NO_MERGE NO_PARALLEL_SCAN */ id, body from px_rnd_t where id <= 3 order by id desc) s) d;
show trace;

evaluate 'Case 14: trace - plain ORDER BY of 2 rows, no more rows than its degree, has no parallel worker line';
select /*+ NO_PARALLEL_SCAN */ count(*) cnt, sum(cast(o as bigint) * id) ord_sum, sum(length(body)) sum_len
  from (select rownum o, id, body from (select /*+ NO_MERGE NO_PARALLEL_SCAN */ id, body from px_rnd_t where id <= 2 order by id desc) s) d;
show trace;

set trace off;

drop table px_rnd_t;
drop table px_grp_t;
drop table px_ord_t;
drop table px_empty_t;
drop table px_wide_t;
drop table px_key_t;
drop table px_sort_t;
