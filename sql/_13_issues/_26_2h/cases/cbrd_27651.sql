/**
 *  This test case verifies CBRD-27651: a parallel hash join returns the serial result when its join
 *  condition calls a function.
 *
 *  A parallel hash join gives each worker its own copy of the join condition (cubxasl::spawner).
 *  The copy of a function call (a regu variable of TYPE_FUNC: ELT, REGEXP_LIKE, REGEXP_REPLACE, ...)
 *  read the function node from the copy itself instead of the original, so the worker's function node
 *  was NULL and the server crashed when the worker evaluated it. The fix copies the original's node
 *  and frees what the worker's copy now builds: a constant argument of the function and the pattern a
 *  REGEXP_* function compiles. It also frees the pattern RLIKE compiles into the worker's copy, which
 *  was not freed before the fix either.
 *
 *  Every tested query runs with trace on over a parallel hash join and is followed by the same query
 *  with no_parallel_hash_join, whose result block must match. test_mode lowers the page threshold of
 *  the parallel hash join to 0, so the trace shows the parallel workers of the HASHJOIN as tokens.
 *  Each condition keeps about half of the joined rows, so a condition the worker evaluates wrongly
 *  changes the count. Every function reads columns of both tables: the same queries with a function
 *  of one table's columns returned the serial result on a build without the fix.
 *
 *  Coverage:
 *    Case 1 - 5: the hash table fits in memory and only the probe runs in parallel
 *      Case 1:  ELT in the WHERE clause (the reported query)
 *      Case 2:  REGEXP_REPLACE with constant arguments inside LENGTH
 *      Case 3:  REGEXP_LIKE (a REGEXP_* function compiles its pattern into the worker's copy)
 *      Case 4:  RLIKE (a predicate, not a function: runs the free of the pattern compiled into the
 *               worker's copy; its result does not depend on the fix)
 *      Case 5:  ELT in the ON clause of a LEFT OUTER JOIN
 *    Case 6 - 8: a small max_hash_list_scan_size splits the join into partitions that run in parallel
 *      Case 6:  ELT in the WHERE clause
 *      Case 7:  REGEXP_LIKE in the WHERE clause
 *      Case 8:  REGEXP_LIKE in the ON clause of a LEFT OUTER JOIN
 */

drop table if exists t;

-- 20000 rows; k is unique, so the equi-join pairs each row with itself and the condition decides the rest
create table t (k int, pad varchar (64));
insert into t select rownum, md5 (rownum) from db_class a, db_class b, db_class c limit 20000;
update statistics on t with fullscan;

set trace on;


evaluate 'Case 1: ELT in the WHERE clause, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.k) from t a, t b where a.k = b.k and elt (b.k % 2 + 1, a.pad, null) is not null;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.k) from t a, t b where a.k = b.k and elt (b.k % 2 + 1, a.pad, null) is not null;


evaluate 'Case 2: REGEXP_REPLACE inside LENGTH, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.k) from t a, t b where a.k = b.k and length (regexp_replace (a.pad || b.k, '[a-f]', '')) % 2 = 0;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.k) from t a, t b where a.k = b.k and length (regexp_replace (a.pad || b.k, '[a-f]', '')) % 2 = 0;


evaluate 'Case 3: REGEXP_LIKE, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.k) from t a, t b where a.k = b.k and regexp_like (a.pad || b.pad, '^[0-7]') = 1;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.k) from t a, t b where a.k = b.k and regexp_like (a.pad || b.pad, '^[0-7]') = 1;


evaluate 'Case 4: RLIKE, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.k) from t a, t b where a.k = b.k and a.pad || b.pad rlike '^[0-7]';
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.k) from t a, t b where a.k = b.k and a.pad || b.pad rlike '^[0-7]';


evaluate 'Case 5: ELT in the ON clause of a LEFT OUTER JOIN, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), count (b.k), sum (b.k) from t a left outer join t b on a.k = b.k and elt (b.k % 2 + 1, a.pad, null) is not null;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), count (b.k), sum (b.k) from t a left outer join t b on a.k = b.k and elt (b.k % 2 + 1, a.pad, null) is not null;


-- the hash table no longer fits, so the join splits into partitions
set system parameters 'max_hash_list_scan_size=64k';


evaluate 'Case 6: ELT in the WHERE clause, parallel partitions; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.k) from t a, t b where a.k = b.k and elt (b.k % 2 + 1, a.pad, null) is not null;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.k) from t a, t b where a.k = b.k and elt (b.k % 2 + 1, a.pad, null) is not null;


evaluate 'Case 7: REGEXP_LIKE in the WHERE clause, parallel partitions; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.k) from t a, t b where a.k = b.k and regexp_like (a.pad || b.pad, '^[0-7]') = 1;
show trace;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.k) from t a, t b where a.k = b.k and regexp_like (a.pad || b.pad, '^[0-7]') = 1;


evaluate 'Case 8: REGEXP_LIKE in the ON clause of a LEFT OUTER JOIN, parallel partitions; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), count (b.k), sum (b.k) from t a left outer join t b on a.k = b.k and regexp_like (a.pad || b.pad, '^[0-7]') = 1;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the session
set trace off;
select /*+ recompile use_hash no_parallel_hash_join */ count (*), count (b.k), sum (b.k) from t a left outer join t b on a.k = b.k and regexp_like (a.pad || b.pad, '^[0-7]') = 1;


set system parameters 'max_hash_list_scan_size=default';

drop table t;
