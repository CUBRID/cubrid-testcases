/*
 * This test case verifies CBRD-27332 : the decision to abandon hash
 * aggregation (hash GROUP BY) is taken against a cutoff that scales with
 * the number of tuples seen.
 *
 * qexec_hash_gby_agg_tuple() (query_executor.c) hashes the GROUP BY input
 * and, every 2,000 tuples, compares the cumulative unique ratio
 * groups / tuples with a cutoff, above the cutoff the hash table is dumped to
 * the partial list and every further tuple bypasses hashing and goes to the
 * sort (HS_REJECT_ALL). Before the change the cutoff was a fixed 0.5 applied
 * at 2,000 tuples: a low-cardinality key whose repeats have not accumulated
 * yet (birthday problem) looked unique and was wrongly abandoned, and in a
 * parallel scan every worker abandoned its partial aggregation. The change
 * (qexec_hash_gby_abandon_cutoff) starts the cutoff at 0.95 for 2,000 tuples
 * and decays it on a log scale to 0.5 at 300,000 tuples, applies the same
 * test when the hash table exceeds max_agg_hash_size (2MB), and holds the
 * cutoff at 0.95 for inputs of 2,000 tuples or fewer (the budget check can
 * fire earlier with wide keys, where the log curve would exceed 1.0 and make
 * abandoning impossible).
 *
 * Abandoning only changes how the groups are computed (hash, hash then sort,
 * or sort only), never the groups themselves, so each check below runs the
 * query once with hashing disabled and parallelism off
 * (NO_HASH_AGGREGATE PARALLEL(1): the plain serial sort GROUP BY reference)
 * and once with the default hash GROUP BY on the automatic parallel degree,
 * and prints order-independent checksums of the groups. The two must match
 * and equal the values that follow from the data definition. SHOW TRACE is
 * deliberately not used (timings are not masked).
 *
 * Data: hg_t 20,000 rows, about 160 heap pages (100-byte pad) so the heap is
 *       scanned in parallel under test_mode (threshold 32 pages) and each
 *       worker runs its own hash context on its share of the rows,
 *       id = 1..20000, k_uniq = (id * 7919) mod 20000 (unique, scrambled),
 *       k_few = id mod 50 (50 keys), k_mid = ((id * 7919) mod 20021) mod 5000
 *       (5,000 keys, 3 to 5 rows each, scattered: 87% of the first 2,000
 *       rows are distinct), v = id mod 1000.
 *       hg_wide 1,500 rows, key_s = 2,000-character unique strings so that
 *       the 2MB hash budget is exceeded before 2,000 tuples.
 *
 *   Case 1: 1,500 rows, unique key  : below 2,000 tuples, hash kept
 *   Case 2: 1,500 rows, 50 keys     : below 2,000 tuples, hash kept
 *   Case 3: 1,500 rows, 2KB unique keys: budget exceeded before 2,000 tuples,
 *           cutoff held at 0.95, ratio 1.0 -> abandoned (NO_PARALLEL_SCAN so
 *           one hash context sees all 3MB of keys), plus the parallel run
 *   Case 4: 20,000 rows, unique key : ratio 1.0 > 0.95 at 2,000 -> abandoned
 *   Case 5: 20,000 rows, 50 keys    : ratio ~0.03 -> hash kept
 *   Case 6: 20,000 rows, 5,000 scattered keys: ratio ~0.87 at 2,000 tuples,
 *           kept under the new cutoff (abandoned under the old 0.5)
 *   Case 7: HAVING + ORDER BY + LIMIT on the 50-key GROUP BY, rows printed
 */

drop table if exists hg_t, hg_wide;

create table hg_t (id int, k_uniq int, k_few int, k_mid int, v int, pad char(100));
insert into hg_t
  select rownum, mod(rownum * 7919, 20000), mod(rownum, 50), mod(mod(rownum * 7919, 20021), 5000), mod(rownum, 1000), lpad('x', 100, 'x')
  from db_class a, db_class b, db_class c, db_class d limit 20000;

create table hg_wide (key_s varchar(2100), v int);
insert into hg_wide select lpad(rownum, 2000, '0'), mod(rownum, 1000) from db_class a, db_class b, db_class c limit 1500;

select count(*), count(distinct k_uniq), count(distinct k_few), count(distinct k_mid) from hg_t;
select count(*), count(distinct key_s), min(length(key_s)), max(length(key_s)) from hg_wide;

-- Case 1: 1,500 rows, unique key (fewer than 2,000 tuples: the very-high-selectivity check never fires)
--         expected: 1500 groups, 1500 rows, sum k 15014250, sum v 624750
evaluate '[1] 1,500 rows, unique key: sort reference / hash GROUP BY';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ k_uniq kk, count(*) cnt, sum(v) sv from hg_t where id <= 1500 group by k_uniq) d;
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select k_uniq kk, count(*) cnt, sum(v) sv from hg_t where id <= 1500 group by k_uniq) d;

-- Case 2: 1,500 rows, 50 keys (30 rows each)
--         expected: 50 groups, 1500 rows, sum k 1225, sum v 624750, every group count 30
evaluate '[2] 1,500 rows, 50 keys: sort reference / hash GROUP BY';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v, min(cnt) min_cnt, max(cnt) max_cnt
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ k_few kk, count(*) cnt, sum(v) sv from hg_t where id <= 1500 group by k_few) d;
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v, min(cnt) min_cnt, max(cnt) max_cnt
  from (select k_few kk, count(*) cnt, sum(v) sv from hg_t where id <= 1500 group by k_few) d;

-- Case 3: 1,500 rows with 2,000-character unique keys: the 2MB hash budget is exceeded before 2,000 tuples
--         expected: 1500 groups, 1500 rows, key length sum 3000000, sum v 624750, key tails 000001 / 001500
evaluate '[3] 1,500 rows, 2KB unique keys (budget exceeded below 2,000 tuples): sort reference / single hash context / parallel';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(length(ks)) sum_key_len, sum(sv) sum_v, substr(min(ks), 1995, 6) min_key_tail, substr(max(ks), 1995, 6) max_key_tail
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ key_s ks, count(*) cnt, sum(v) sv from hg_wide group by key_s) d;
select count(*) grp_cnt, sum(cnt) row_cnt, sum(length(ks)) sum_key_len, sum(sv) sum_v, substr(min(ks), 1995, 6) min_key_tail, substr(max(ks), 1995, 6) max_key_tail
  from (select /*+ NO_PARALLEL_SCAN */ key_s ks, count(*) cnt, sum(v) sv from hg_wide group by key_s) d;
select count(*) grp_cnt, sum(cnt) row_cnt, sum(length(ks)) sum_key_len, sum(sv) sum_v, substr(min(ks), 1995, 6) min_key_tail, substr(max(ks), 1995, 6) max_key_tail
  from (select key_s ks, count(*) cnt, sum(v) sv from hg_wide group by key_s) d;

-- Case 4: 20,000 rows, unique key: abandoned at the first check (ratio 1.0 > 0.95)
--         expected: 20000 groups, 20000 rows, sum k 199990000, sum v 9990000
evaluate '[4] 20,000 rows, unique key (abandoned at 2,000 tuples): sort reference / hash GROUP BY';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ k_uniq kk, count(*) cnt, sum(v) sv from hg_t group by k_uniq) d;
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v
  from (select k_uniq kk, count(*) cnt, sum(v) sv from hg_t group by k_uniq) d;

-- Case 5: 20,000 rows, 50 keys (400 rows each): hash kept
--         expected: 50 groups, 20000 rows, sum k 1225, sum v 9990000, every group count 400
evaluate '[5] 20,000 rows, 50 keys (hash kept): sort reference / hash GROUP BY';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v, min(cnt) min_cnt, max(cnt) max_cnt
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ k_few kk, count(*) cnt, sum(v) sv from hg_t group by k_few) d;
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v, min(cnt) min_cnt, max(cnt) max_cnt
  from (select k_few kk, count(*) cnt, sum(v) sv from hg_t group by k_few) d;

-- Case 6: 20,000 rows, 5,000 scattered keys (3 to 5 rows each): ratio about 0.87 at 2,000 tuples -> kept under the new cutoff
--         expected: 5000 groups, 20000 rows, sum k 12497500, sum v 9990000, group counts 3 .. 5
evaluate '[6] 20,000 rows, 5,000 scattered keys (kept under the decaying cutoff): sort reference / hash GROUP BY';
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v, min(cnt) min_cnt, max(cnt) max_cnt
  from (select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ k_mid kk, count(*) cnt, sum(v) sv from hg_t group by k_mid) d;
select count(*) grp_cnt, sum(cnt) row_cnt, sum(kk) sum_k, sum(sv) sum_v, min(cnt) min_cnt, max(cnt) max_cnt
  from (select k_mid kk, count(*) cnt, sum(v) sv from hg_t group by k_mid) d;

-- Case 7: HAVING + ORDER BY + LIMIT on the 50-key GROUP BY, actual rows
--         expected: k_few 0..4, count 400 each, sum v 190000 / 190400 / 190800 / 191200 / 191600, min id 50 1 2 3 4, max id 20000 19951 .. 19954
evaluate '[7] HAVING + ORDER BY + LIMIT on the 50-key GROUP BY: sort reference / hash GROUP BY';
select /*+ NO_HASH_AGGREGATE PARALLEL(1) */ k_few, count(*) cnt, sum(v) sum_v, min(id) min_id, max(id) max_id
  from hg_t group by k_few having count(*) = 400 order by k_few limit 5;
select k_few, count(*) cnt, sum(v) sum_v, min(id) min_id, max(id) max_id
  from hg_t group by k_few having count(*) = 400 order by k_few limit 5;

drop table hg_t, hg_wide;
