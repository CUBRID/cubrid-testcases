/**
 *  This test case verifies CBRD-27177: a GROUP BY that is planned for hash aggregation
 *  but sorts at run time can run that sort in parallel, and gives the same rows.
 *
 *  Before the fix (engine PR #7625) the GROUP BY sort asked for parallel workers only when
 *  the plan did not choose hash aggregation. When the hash aggregation gave up at run time
 *  (too many distinct keys), or left its entries in a partial list to be sorted, both sorts
 *  stayed serial. The fix decides on the run-time hash state for the main sort and lets
 *  the partial-list sort ask for workers as well.
 *
 *  Each tested query is followed by the same query with no_hash_aggregate parallel(0),
 *  the serial sort GROUP BY, and the two result blocks must match. The trace proves the
 *  new path: the GROUPBY line (hash: partial or hash: true, sort: true) is followed by a
 *  parallel workers line, which the pre-fix build does not print. CTP masks the digits,
 *  so only the presence of that line is asserted. HAVING keeps the output to the groups
 *  of different sizes.
 *
 *  Coverage:
 *    Case 1:  serial scan, the hash aggregation gives up on distinct keys (hash: partial)
 *    Case 2:  serial scan, the hash aggregation is kept and its partial list is sorted (hash: true)
 *    Case 3:  parallel heap scan, the workers' partial lists are sorted by the main thread
 */

drop table if exists t_num, t_grp, t_reject, t_keep;

-- numbers 1..4000 for the generators below
create table t_num (n int);
insert into t_num select rownum from db_class a, db_class b, db_class c limit 4000;

-- eight output groups of different sizes (g more rows in t_reject, cnt / 25 rows in t_keep)
create table t_grp (g int, cnt int);
insert into t_grp values (1, 1750), (2, 2000), (3, 2250), (4, 2500), (5, 2750), (6, 3000), (7, 3250), (8, 3500);

-- keys 1..20000 with one row each (v = 0), then 10 NULL keys and g more rows (v = 1..g) for keys 1..8. Only 45 rows
-- repeat a key, so whatever the heap order, at least 1955 of the first 2000 rows the hash aggregation reads have
-- distinct keys and it gives up (the abandon cutoff is 0.5 on older builds, 0.95 at 2000 rows since CBRD-27332)
create table t_reject (k int, v int);
insert into t_reject select rownum, 0 from t_num a, t_num b limit 20000;
insert into t_reject select null, n from t_num where n <= 10;
insert into t_reject select g.g, n.n from t_grp g, t_num n where n.n <= g.g;

-- 25000 keys with four adjacent rows each keep the distinct ratio near 0.25, so the hash aggregation never gives up.
-- 100000 rows are scanned in parallel when the hint allows it. Then the eight groups as keys 25001..25008 with cnt / 25 rows
create table t_keep (k int, v int);
insert into t_keep select (rownum - 1) div 4 + 1, mod(rownum, 7) from t_num a, t_num b limit 100000;
insert into t_keep select 25000 + g.g, n.n from t_grp g, t_num n where n.n <= g.cnt / 25;

update statistics on t_num, t_grp, t_reject, t_keep with fullscan;

set trace on;


evaluate 'Case 1: serial scan, hash aggregation gives up, parallel GROUP BY sort; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), min(v), max(v) from t_reject group by k having count(*) > 1 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_reject group by k having count(*) > 1 order by k;


evaluate 'Case 2: serial scan, hash aggregation kept, parallel partial-list sort; result = no_hash_aggregate parallel(0)';
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), min(v), max(v) from t_keep group by k having count(*) > 4 order by k;
show trace;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_keep group by k having count(*) > 4 order by k;


evaluate 'Case 3: parallel heap scan, workers partial lists sorted in parallel; result = no_hash_aggregate parallel(0)';
select /*+ recompile */ k, count(*), sum(v), min(v), max(v) from t_keep group by k having count(*) > 4 order by k;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_hash_aggregate parallel(0) */ k, count(*), sum(v), min(v), max(v) from t_keep group by k having count(*) > 4 order by k;


drop table t_num, t_grp, t_reject, t_keep;
