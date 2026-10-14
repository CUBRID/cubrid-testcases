/**
 *  This test case verifies CBRD-27177: a GROUP BY planned for hash aggregation that sorts at
 *  run time can run that sort in parallel, and gives the same rows.
 *
 *  Before the fix (engine PR #7625) such a GROUP BY never sorted in parallel. The fix decides
 *  on the run-time hash state: once the hash aggregation gives up, the GROUP BY sort may ask
 *  for workers, and the sort of the partial list the hash table leaves may ask for them too.
 *  While the hash aggregation is kept, the GROUP BY sort stays serial as before.
 *
 *  Each tested query is followed by the same query with no_hash_aggregate parallel(0), and
 *  the result blocks must match. The trace shows the path: hash true or partial on the
 *  GROUPBY line, and a parallel workers line under it only when a sort ran in parallel. CTP
 *  masks the digits, so only the presence of that line is asserted.
 *
 *  Coverage:
 *    Case 1:  serial scan, hashing gives up at its first check, parallel GROUP BY sort
 *    Case 2:  serial scan, hashing kept, its partial list sorted in parallel
 *    Case 3:  parallel heap scan, the partial lists of the workers sorted in parallel
 *    Case 4:  hashing kept, GROUP BY sort and one-page partial list serial
 *    Case 5:  hashing gives up midway, its partial results merged into the parallel sort
 *    Case 6:  WITH ROLLUP after hashing gives up
 *    Case 7:  parallel(1) and parallel(2) on the GROUP BY sort after hashing gives up
 *    Case 8:  parallel(1) and parallel(2) on the partial list sort
 *    Case 9:  empty input and agg_hash_respect_order=no, which skip both sorts
 */

drop table if exists t_num, t_reject, t_keep, t_small, t_mid;

-- numbers 1..4000 for the generators below
create table t_num (n int);
insert into t_num select rownum from db_class a, db_class b, db_class c limit 4000;

-- keys 1..20000 once each (v = 0), then 8 NULL keys and k more rows (v = 1..k) for keys 1..4. Only 17 rows repeat a key,
-- so in any heap order at least 1983 of the first 2000 rows hashed are distinct (0.99, against the give-up cutoff of 0.5
-- on older builds and 0.95 at 2000 rows since CBRD-27332), and every later check gives up as well (0.999 distinct)
create table t_reject (k int, v int);
insert into t_reject select rownum, 0 from t_num a, t_num b limit 20000;
insert into t_reject select null, n from t_num where n <= 8;
insert into t_reject select a.n, b.n from t_num a, t_num b where a.n <= 4 and b.n <= a.n;

-- keys 1..200 fifty times each with a 512-character pad that is part of the group key, then k more rows for keys 1..8.
-- 200 keys give a distinct ratio of at most 0.1 at the first check in any heap order (1/5 of the lowest cutoff 0.5).
-- The 200 hash entries fit the 2 MB hash memory limit even with six times wider pads, the partial list of a third of
-- the keys still spans the 2-page parallel sort floor of CTP, and the rows of about 550 bytes fill about 350 heap
-- pages, 10 times the 32-page parallel heap scan threshold of CTP
create table t_keep (k int, v int, pad varchar(600));
insert into t_keep select s.k, s.v, sha2(s.k * 4 + 1, 512) || sha2(s.k * 4 + 2, 512) || sha2(s.k * 4 + 3, 512) || sha2(s.k * 4 + 4, 512) from (select mod(rownum - 1, 200) + 1 as k, mod(rownum, 7) as v from t_num a, t_num b limit 10000) s;
insert into t_keep select a.n, b.n, sha2(a.n * 4 + 1, 512) || sha2(a.n * 4 + 2, 512) || sha2(a.n * 4 + 3, 512) || sha2(a.n * 4 + 4, 512) from t_num a, t_num b where a.n <= 8 and b.n <= a.n;

-- keys 1..300 once each (v = 0) with a 512-character pad, then k more rows for keys 1..8. 336 rows never reach the first
-- give-up check at 2000 rows. The group key is k alone, so only 8 partial results exist (one page), while the first rows
-- of the 300 groups carry the pad: a third of them still spans the 2-page parallel sort floor, and the hash table fits
-- the 2 MB hash memory limit even with six times wider pads
create table t_small (k int, v int, pad varchar(600));
insert into t_small select n, 0, sha2(n * 4 + 1, 512) || sha2(n * 4 + 2, 512) || sha2(n * 4 + 3, 512) || sha2(n * 4 + 4, 512) from t_num where n <= 300;
insert into t_small select a.n, b.n, sha2(a.n * 4 + 1, 512) || sha2(a.n * 4 + 2, 512) || sha2(a.n * 4 + 3, 512) || sha2(a.n * 4 + 4, 512) from t_num a, t_num b where a.n <= 8 and b.n <= a.n;

-- keys 1..1000 four times in a row, then 76000 keys once, then k more rows for keys 1..8. The whole table is 0.96
-- distinct, more than any cutoff (at most 0.95), so hashing gives up by the last check in any heap order. In insert
-- order it gives up after the repeated keys were hashed, and their partial results meet the rows of keys 1..8 read later
create table t_mid (k int, v int);
insert into t_mid select case when rownum <= 4000 then (rownum - 1) div 4 + 1 else rownum - 3000 end, mod(rownum, 7) from t_num a, t_num b limit 80000;
insert into t_mid select a.n, b.n from t_num a, t_num b where a.n <= 8 and b.n <= a.n;

update statistics on t_num, t_reject, t_keep, t_small, t_mid with fullscan;

set trace on;


evaluate 'Case 1: serial scan, hashing gives up at its first check, parallel GROUP BY sort; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), min(v), max(v) from t_reject group by k having count(*) > 1 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_reject group by k having count(*) > 1 order by k;


evaluate 'Case 2: serial scan, hashing kept, partial list sorted in parallel; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), min(v), max(v) from t_keep group by k, pad having count(*) > 50 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_keep group by k, pad having count(*) > 50 order by k;


evaluate 'Case 3: parallel heap scan, partial lists of the workers sorted in parallel; result = no_hash_aggregate parallel(0)';
select /*+ recompile */ k, count(*), sum(v), min(v), max(v) from t_keep group by k, pad having count(*) > 50 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_keep group by k, pad having count(*) > 50 order by k;


evaluate 'Case 4: hashing kept, GROUP BY sort and one-page partial list serial, no_hash_aggregate sorts in parallel; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), count(pad), sum(v), min(v), max(v) from t_small group by k having count(*) > 1 order by k;
show trace;
select /*+ recompile no_hash_aggregate no_parallel_scan */ k, count(*), count(pad), sum(v), min(v), max(v) from t_small group by k having count(*) > 1 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), count(pad), sum(v), min(v), max(v) from t_small group by k having count(*) > 1 order by k;


evaluate 'Case 5: hashing gives up midway, partial results merged into the parallel sort; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), min(v), max(v) from t_mid group by k having count(*) > 4 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_mid group by k having count(*) > 4 order by k;


evaluate 'Case 6: WITH ROLLUP after hashing gives up; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ mod(k, 3) as m, k, count(*), sum(v) from t_reject group by mod(k, 3), k with rollup having count(*) > 1 order by 1, 2, 3;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ mod(k, 3) as m, k, count(*), sum(v) from t_reject group by mod(k, 3), k with rollup having count(*) > 1 order by 1, 2, 3;


evaluate 'Case 7: parallel(1) keeps the GROUP BY sort serial, parallel(2) runs it in parallel; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan parallel(1) */ k, count(*), sum(v), min(v), max(v) from t_reject group by k having count(*) > 1 order by k;
show trace;
select /*+ recompile no_parallel_scan parallel(2) */ k, count(*), sum(v), min(v), max(v) from t_reject group by k having count(*) > 1 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_reject group by k having count(*) > 1 order by k;


evaluate 'Case 8: parallel(1) keeps the partial list sort serial, parallel(2) runs it in parallel; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan parallel(1) */ k, count(*), sum(v), min(v), max(v) from t_keep group by k, pad having count(*) > 50 order by k;
show trace;
select /*+ recompile no_parallel_scan parallel(2) */ k, count(*), sum(v), min(v), max(v) from t_keep group by k, pad having count(*) > 50 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_keep group by k, pad having count(*) > 50 order by k;


evaluate 'Case 9: empty input and agg_hash_respect_order=no skip both sorts; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), count(pad), sum(v), min(v), max(v) from t_small where v < 0 group by k order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), count(pad), sum(v), min(v), max(v) from t_small where v < 0 group by k order by k;
set system parameters 'agg_hash_respect_order=no';
select /*+ recompile no_parallel_scan */ k, count(*), count(pad), sum(v), min(v), max(v) from t_small group by k having count(*) > 1 order by k;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), count(pad), sum(v), min(v), max(v) from t_small group by k having count(*) > 1 order by k;
set system parameters 'agg_hash_respect_order=default';


drop table t_num, t_reject, t_keep, t_small, t_mid;
