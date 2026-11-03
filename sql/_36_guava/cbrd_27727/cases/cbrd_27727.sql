/**
 *  This test case verifies CBRD-27727: a hash GROUP BY sorts in parallel whatever its hash
 *  state, and its trace says partial when any hash context gave up hashing, true otherwise.
 *
 *  Before the fix (engine PR #8241) the GROUP BY sort asked for workers only when the leader
 *  gave up hashing, so under a parallel heap scan, where the workers hash and give up on their
 *  own, it always sorted serially, and the trace printed hash partial for every parallel scan.
 *
 *  Each tested query is followed by the same GROUP BY with no_hash_aggregate parallel(0), and
 *  the result blocks must match. The trace shows the path: a parallel workers line directly
 *  under GROUPBY when a sort ran in parallel, and hash true, partial or false. CTP masks the
 *  digits, so only the presence of the line and the hash word are asserted. The outer blocks
 *  carry no_parallel_scan so that only the GROUP BY block runs in parallel.
 *
 *  Coverage:
 *    Case 1:  parallel scan, every worker gives up, GROUP BY sort parallel (issue repro)
 *    Case 2:  two workers, one gives up and one keeps hashing, hash partial
 *    Case 3:  every worker keeps hashing, hash true
 *    Case 4:  partitions, serial and parallel passes, one context gives up, hash partial
 *    Case 5:  parallel scan that hashes no row, hash false as in the serial scan
 *    Case 6:  serial scan keeps hashing, GROUP BY sort parallel above the 2-page floor
 *    Case 7:  correlated GROUP BY subquery run by the scan workers, one run gives up
 */

drop table if exists t_num, t_uniq, t_mix, t_kept, t_part, t_lead, t_wide, t_out, t_in;

-- numbers 1..4000 for the generators below
create table t_num (n int);
insert into t_num select rownum from db_class a, db_class b, db_class c limit 4000;

-- every key once: each worker gives up hashing at its first check (2000 rows, all distinct) and leaves no partial result, so a
-- parallel workers line under GROUPBY comes from the main sort. 40000 rows with a 192-character incompressible pad fill about
-- 550 heap pages (17x the 32-page parallel scan threshold of CTP), at least two 64-page sectors per worker
create table t_uniq (id int, k int, v int, pad varchar(200));
insert into t_uniq select rownum, mod(rownum * 7919, 40000), mod(rownum, 1000), sha2(rownum, 512) || substr(sha2(rownum + 1, 512), 1, 64)
  from t_num a, t_num b limit 40000;

-- a parallel heap scan gives each worker a contiguous range of sectors, the partially filled last sector first. The first 10000
-- and the last 5000 rows (more than one sector) have distinct keys and the rest 5 keys with different row counts: under
-- parallel(2) the first worker starts on distinct keys and gives up with no partial result, the second keeps hashing at most
-- 5000 small entries (a quarter of the 2 MB hash memory) and leaves one page of partial results, so the partial list sorts
-- serially and a parallel workers line under GROUPBY comes from the main sort. 66000 rows fill about 900 pages
create table t_mix (id int, k int, v int, pad varchar(200));
insert into t_mix select rownum, case when rownum <= 10000 or rownum > 61000 then 100000 + rownum
  when mod(rownum, 15) < 5 then 0 when mod(rownum, 15) < 9 then 1 when mod(rownum, 15) < 12 then 2 when mod(rownum, 15) < 14 then 3 else 4 end,
  mod(rownum, 1000), sha2(rownum, 512) || substr(sha2(rownum + 1, 512), 1, 64) from t_num a, t_num b limit 66000;

-- 5 keys with different row counts in every sector: every worker keeps hashing
create table t_kept (id int, k int, v int, pad varchar(200));
insert into t_kept select rownum, case when mod(rownum, 15) < 5 then 0 when mod(rownum, 15) < 9 then 1 when mod(rownum, 15) < 12 then 2
  when mod(rownum, 15) < 14 then 3 else 4 end, mod(rownum, 1000), sha2(rownum, 512) || substr(sha2(rownum + 1, 512), 1, 64)
  from t_num a, t_num b limit 66000;

-- one pass per partition: p_head and p_tail are 2 pages (scanned serially, the leader hashes and keeps), p_uniq has distinct keys
-- (about 280 pages, parallel, the workers give up), p_few 5 keys (parallel, the workers keep). The leader scans p_tail last
create table t_part (id int, k int, v int, pad varchar(200))
  partition by range (id) (partition p_head values less than (100), partition p_uniq values less than (20100),
                           partition p_few values less than (40100), partition p_tail values less than maxvalue);
insert into t_part select rownum, case when rownum >= 100 and rownum < 20100 then 100000 + rownum when mod(rownum, 15) < 5 then 0
  when mod(rownum, 15) < 9 then 1 when mod(rownum, 15) < 12 then 2 when mod(rownum, 15) < 14 then 3 else 4 end,
  mod(rownum, 1000), sha2(rownum, 512) || substr(sha2(rownum + 1, 512), 1, 64) from t_num a, t_num b limit 40198;

-- the leader gives up first: p_lead holds 2500 distinct keys with no pad (about 5 pages, serial, it gives up at 2000 rows),
-- p_rest 20000 rows of 5 keys with the pad (about 280 pages, parallel, the workers keep)
create table t_lead (id int, k int, v int, pad varchar(200))
  partition by range (id) (partition p_lead values less than (2501), partition p_rest values less than maxvalue);
insert into t_lead select rownum, case when rownum <= 2500 then 100000 + rownum when mod(rownum, 15) < 5 then 0 when mod(rownum, 15) < 9 then 1
  when mod(rownum, 15) < 12 then 2 when mod(rownum, 15) < 14 then 3 else 4 end, mod(rownum, 1000),
  case when rownum <= 2500 then null else sha2(rownum, 512) || substr(sha2(rownum + 1, 512), 1, 64) end from t_num a, t_num b limit 22500;

-- 300 keys of 4 rows: 1200 rows never reach the first give-up check, so hashing is kept. count(pad) puts the 896-character
-- incompressible pad into the first row of each group: the main sort reads about 17 pages (8x the 2-page parallel sort floor
-- of CTP) while 300 hash entries stay far under the 2 MB hash memory. Three keys fit one page and sort serially
create table t_wide (k int, v int, pad varchar(1000));
insert into t_wide select mod(n, 300), mod(n, 7), sha2(mod(n, 300) * 8 + 1, 512) || sha2(mod(n, 300) * 8 + 2, 512) || sha2(mod(n, 300) * 8 + 3, 512)
  || sha2(mod(n, 300) * 8 + 4, 512) || sha2(mod(n, 300) * 8 + 5, 512) || sha2(mod(n, 300) * 8 + 6, 512) || sha2(mod(n, 300) * 8 + 7, 512)
  from t_num where n <= 1200;

-- outer table of 20000 rows with a 64-character pad (about 110 pages, parallel scan with a buildvalue gather); inner rows of
-- g = 1 have 3000 distinct keys (that run gives up hashing), every other g has 3 rows of one key (those runs keep hashing)
create table t_out (a int, pad varchar(100));
insert into t_out select rownum, substr(sha2(rownum, 512), 1, 64) from t_num a, t_num b limit 20000;
create table t_in (g int, k int, v int);
insert into t_in select 1, n, mod(n, 7) from t_num where n <= 3000;
insert into t_in select a, 0, 1 from t_out;
insert into t_in select a, 0, 2 from t_out;
insert into t_in select a, 0, 3 from t_out;
create index i_in_g on t_in (g);

update statistics on t_uniq, t_mix, t_kept, t_part, t_lead, t_wide, t_out, t_in with fullscan;

set trace on;


evaluate 'Case 1: every worker gives up hashing, GROUP BY sort parallel; result = no_parallel_scan = parallel(1) = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select k, count(*) cnt, sum(v) sv from t_uniq group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select /*+ no_parallel_scan */ k, count(*) cnt, sum(v) sv from t_uniq group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select /*+ parallel(1) */ k, count(*) cnt, sum(v) sv from t_uniq group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select /*+ no_hash_aggregate parallel(0) */ k, count(*) cnt, sum(v) sv from t_uniq group by k) d;


evaluate 'Case 2: parallel(2), the first worker gives up and the second keeps hashing, GROUP BY sort parallel, hash partial; result = no_hash_aggregate parallel(0)';
select /*+ recompile parallel(2) */ k, count(*), sum(v) from t_mix group by k having count(*) > 1 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v) from t_mix group by k having count(*) > 1 order by k;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select /*+ parallel(2) */ k, count(*) cnt, sum(v) sv from t_mix group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select /*+ no_hash_aggregate parallel(0) */ k, count(*) cnt, sum(v) sv from t_mix group by k) d;


evaluate 'Case 3: every worker keeps hashing, hash true; result = no_hash_aggregate parallel(0)';
select /*+ recompile */ k, count(*), sum(v) from t_kept group by k order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v) from t_kept group by k order by k;


evaluate 'Case 4: partitions, a parallel pass gives up and a later serial pass keeps hashing, then the leader gives up first, hash partial both times; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select k, count(*) cnt, sum(v) sv from t_part group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select /*+ no_hash_aggregate parallel(0) */ k, count(*) cnt, sum(v) sv from t_part group by k) d;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select k, count(*) cnt, sum(v) sv from t_lead group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt), sum(cast(k as bigint) * cnt), sum(sv) from (select /*+ no_hash_aggregate parallel(0) */ k, count(*) cnt, sum(v) sv from t_lead group by k) d;


evaluate 'Case 5: parallel scan whose filter keeps no row, hash false as in the serial scan; result = no_parallel_scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cnt) from (select k, count(*) cnt from t_uniq where v < 0 group by k) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(cnt) from (select /*+ no_parallel_scan */ k, count(*) cnt from t_uniq where v < 0 group by k) d;
show trace;


evaluate 'Case 6: serial scan keeps hashing, GROUP BY sort parallel, three groups stay serial; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), count(pad), sum(v) from t_wide group by k order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), count(pad), sum(v) from t_wide group by k order by k;
select /*+ recompile no_parallel_scan */ k, count(*), count(pad), sum(v) from t_wide where k < 3 group by k order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), count(pad), sum(v) from t_wide where k < 3 group by k order by k;


evaluate 'Case 7: correlated GROUP BY subquery run by the scan workers, the run for g = 1 gives up hashing, hash partial; result = no_parallel_scan with no_hash_aggregate';
select /*+ recompile */ count(*), sum(s) from (select a, (select count(*) from (select k, count(*) c from t_in i where i.g = o.a group by k) x) s from t_out o) z;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile */ count(*), sum(s) from (select /*+ no_parallel_scan */ a, (select count(*) from (select /*+ no_hash_aggregate */ k, count(*) c from t_in i where i.g = o.a group by k) x) s from t_out o) z;

drop table t_num, t_uniq, t_mix, t_kept, t_part, t_lead, t_wide, t_out, t_in;
