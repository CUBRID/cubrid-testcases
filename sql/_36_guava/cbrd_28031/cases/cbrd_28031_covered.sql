/**
 *  This test case verifies CBRD-28031: a covered index scan hands each row to the query block
 *  where the B-tree selects it, and the rows, the errors and the trace lines stay the same.
 *
 *  Before the change a covered index scan wrote every key to a temporary list and the block
 *  read the list back row by row.
 *
 *  Each case runs the query on the covering index, prints its trace, and runs a twin that
 *  reads the heap with no index. The two result blocks must be equal. The trace shows the
 *  covered index scan by its tokens only, because CTP masks the digits. No hint or parameter
 *  brings the list back, so the build before the change passes this file too.
 *
 *  Coverage:
 *    Case 1:  aggregate over a covered index scan
 *    Case 2:  covered index scan read through an inline view
 *    Case 3:  covered inner scan of a join on a unique outer key, keys with overflow pages
 *    Case 4:  covered inner scan of a join on a unique outer key, a key range for each outer row
 *    Case 5:  covered inner scan of a join that memoizes on a repeating outer key
 *    Case 6:  hash GROUP BY over a covered index scan
 *    Case 7:  covered index scan in a block that runs a subquery for each row
 *    Case 8:  error in the middle of a covered index scan, then the same keys with no error
 */

drop table if exists cv_t;

-- 100,000 rows: k has 4 rows for each key, grp has 10,000 rows for each key (overflow pages), s
-- cannot be cast to int in 4 rows (the error of Case 8). Every query carries no_parallel_scan:
-- the rows of a covered index scan reach the block on the serial path
create table cv_t (id int not null, k int, grp int, s varchar(20));
insert into cv_t select rownum, mod(rownum * 31, 25013), mod(rownum, 10), case when mod(rownum, 25000) = 7 then 'abc' else cast(mod(rownum, 1000) as varchar(20)) end from db_root connect by level <= 100000;
create index i_cv_k on cv_t (k);
create index i_cv_grp on cv_t (grp);
create index i_cv_ks on cv_t (k, s);
update statistics on cv_t with fullscan;

set trace on;


evaluate 'Case 1: aggregate over a covered index scan; result = heap scan';
select /*+ recompile no_parallel_scan */ count(k), sum(cast(k as bigint)), min(k), max(k) from cv_t where k between 25 and 22500 using index i_cv_k(+);
show trace;
select /*+ no_parallel_scan */ count(k), sum(cast(k as bigint)), min(k), max(k) from cv_t where k between 25 and 22500 using index none;


evaluate 'Case 2: covered index scan read through an inline view; result = heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(x.k as bigint)), min(x.s), max(x.s) from (select /*+ no_merge no_parallel_scan */ k, s from cv_t where k between 25 and 12500 using index i_cv_ks(+)) x;
show trace;
select /*+ no_parallel_scan */ count(*), sum(cast(x.k as bigint)), min(x.s), max(x.s) from (select /*+ no_merge no_parallel_scan */ k, s from cv_t where k between 25 and 12500 using index none) x;


evaluate 'Case 3: covered inner scan of a join on a unique outer key, 10,000 rows for each key; result = hash join on the heap';
select /*+ recompile ordered use_nl no_parallel_scan */ a.id, count(*), sum(cast(b.grp as bigint)) from cv_t a, cv_t b where a.id between 1 and 5 and b.grp = a.id group by a.id using index i_cv_grp(+) order by a.id;
show trace;
select /*+ ordered use_hash no_parallel_scan */ a.id, count(*), sum(cast(b.grp as bigint)) from cv_t a, cv_t b where a.id between 1 and 5 and b.grp = a.id group by a.id using index none order by a.id;


evaluate 'Case 4: covered inner scan of a join on a unique outer key, a key range for each outer row; result = join on the heap';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(cast(b.k as bigint)) from cv_t a, cv_t b where a.id between 1 and 50 and b.k between a.id and a.id + 20 using index i_cv_k(+);
show trace;
select /*+ ordered no_parallel_scan */ count(*), sum(cast(b.k as bigint)) from cv_t a, cv_t b where a.id between 1 and 50 and b.k between a.id and a.id + 20 using index none;


-- 40 outer rows hold 20 values of k twice each, so the inner scan keeps its results (the MEMOIZE
-- line of the trace) and reads its rows through the list as before
evaluate 'Case 5: covered inner scan of a join that memoizes on a repeating outer key; result = hash join on the heap';
select /*+ recompile ordered use_nl no_parallel_scan */ a.id, count(*), sum(cast(b.k as bigint)) from cv_t a, cv_t b where (a.id between 1 and 20 or a.id between 25014 and 25033) and b.k = a.k group by a.id using index i_cv_k(+) order by a.id;
show trace;
select /*+ ordered use_hash no_parallel_scan */ a.id, count(*), sum(cast(b.k as bigint)) from cv_t a, cv_t b where (a.id between 1 and 20 or a.id between 25014 and 25033) and b.k = a.k group by a.id using index none order by a.id;


evaluate 'Case 6: hash GROUP BY over a covered index scan; result = heap scan';
select /*+ recompile no_parallel_scan */ mod(k, 7), count(*), sum(cast(k as bigint)) from cv_t where k between 25 and 22500 group by mod(k, 7) using index i_cv_k(+) order by 1;
show trace;
select /*+ no_parallel_scan */ mod(k, 7), count(*), sum(cast(k as bigint)) from cv_t where k between 25 and 22500 group by mod(k, 7) using index none order by 1;


evaluate 'Case 7: covered index scan in a block that runs a subquery for each row; result = join and group';
select /*+ recompile no_parallel_scan */ count(*) from cv_t a where a.k between 25 and 75 and (select count(*) from cv_t b where b.k = a.k) > 3 using index i_cv_k(+);
show trace;
select /*+ no_parallel_scan */ sum(cnt) from (select k, count(*) cnt from cv_t where k between 25 and 75 group by k having count(*) > 3 using index none) x;


evaluate 'Case 8: a row fails in the middle of a covered index scan and in the heap scan (expected errors), then the same keys return the rows of the heap scan';
select /*+ recompile no_parallel_scan */ count(*), sum(cast(s as int)) from cv_t where k between 0 and 25013 using index i_cv_ks(+);
select /*+ no_parallel_scan */ count(*), sum(cast(s as int)) from cv_t where k between 0 and 25013 using index none;
select /*+ recompile no_parallel_scan */ count(*), sum(cast(k as bigint)), min(s), max(s) from cv_t where k between 0 and 25013 using index i_cv_ks(+);
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the first show trace of the next file over a cached plan would print it
set trace off;
select /*+ no_parallel_scan */ count(*), sum(cast(k as bigint)), min(s), max(s) from cv_t where k between 0 and 25013 using index none;

drop table cv_t;
