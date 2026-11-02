/**
 *  This test case verifies CBRD-27598: with trace on, a parallel heap scan whose condition
 *  has a subquery containing a set operation or a hash join returns its rows.
 *
 *  When a parallel scan worker finishes, it merges the trace statistics of the subqueries
 *  it ran into the main plan (xasl_merge_stats). The merge read the scan statistics of every
 *  plan node, but a UNION, DIFFERENCE, INTERSECTION or HASHJOIN node has no scan of its own,
 *  so the server crashed. The fix merges scan statistics only for nodes that have a scan.
 *
 *  Every tested query runs with trace on over a parallel heap scan of t_big and is followed
 *  by the same query with no_parallel_scan, whose result block must match. CTP masks the
 *  digits of the trace, so the traces show the parallel scan of t_big (gather: buildvalue
 *  or mergeable list) and the set operation or hash join in the subquery as tokens.
 *
 *  Coverage:
 *    Case 1:  UNION ALL in an uncorrelated subquery (the reported query)
 *    Case 2:  hash join in a correlated subquery
 *    Case 3:  EXCEPT in a correlated subquery
 *    Case 4:  INTERSECT in a correlated subquery
 *    Case 5:  UNION ALL in a subquery on the inner table of a nested loop join
 *    Case 6:  hash join in an uncorrelated subquery
 */

drop table if exists t_big, t_small;

-- outer table: 100000 rows, about 220 heap pages, about 7 times the parallel heap scan threshold of test_mode (32 pages)
create table t_big (a int, b int);
insert into t_big select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 100000;
-- subquery table: 3 rows; each correlated subquery below looks up one row of it by t_big.a, so no key repeats
create table t_small (a int primary key, b int);
insert into t_small values (1, 1), (2, 2), (3, 3);
update statistics on t_big, t_small with fullscan;

set trace on;


evaluate 'Case 1: UNION ALL in an uncorrelated subquery; result = no_parallel_scan';
select /*+ recompile */ count(*) from t_big where b > (select max (u.v) from (select b v from t_small union all select 0 from db_root) u);
show trace;
select /*+ recompile no_parallel_scan */ count(*) from t_big where b > (select max (u.v) from (select b v from t_small union all select 0 from db_root) u);


evaluate 'Case 2: hash join in a correlated subquery; result = no_parallel_scan';
select /*+ recompile */ a, b from t_big where a <= 10 and b >= (select /*+ use_hash */ max (z.b) from t_small z, t_small y where z.a = y.a and z.a = t_big.a) order by a;
-- only the workers run this hash join, and its own statistics (BUILD and PROBE rows, method) are not merged, so it prints method: skip
show trace;
select /*+ recompile no_parallel_scan */ a, b from t_big where a <= 10 and b >= (select /*+ use_hash */ max (z.b) from t_small z, t_small y where z.a = y.a and z.a = t_big.a) order by a;


evaluate 'Case 3: EXCEPT in a correlated subquery; result = no_parallel_scan';
select /*+ recompile */ a, b from t_big where a <= 10 and b > (select count(*) from (select z.b v from t_small z where z.a = t_big.a except select 2 from db_root) u) order by a;
show trace;
select /*+ recompile no_parallel_scan */ a, b from t_big where a <= 10 and b > (select count(*) from (select z.b v from t_small z where z.a = t_big.a except select 2 from db_root) u) order by a;


evaluate 'Case 4: INTERSECT in a correlated subquery; result = no_parallel_scan';
select /*+ recompile */ a, b from t_big where a <= 10 and b > (select count(*) * 10 from (select z.b v from t_small z where z.a = t_big.a intersect select 3 from db_root) u) order by a;
show trace;
select /*+ recompile no_parallel_scan */ a, b from t_big where a <= 10 and b > (select count(*) * 10 from (select z.b v from t_small z where z.a = t_big.a intersect select 3 from db_root) u) order by a;


evaluate 'Case 5: UNION ALL in a subquery on the inner table of a nested loop join; result = no_parallel_scan';
select /*+ recompile ordered use_nl */ t_big.a, y.b from t_big, t_small y where t_big.a <= 10 and y.a = t_big.a and y.b >= (select max (u.v) from (select z.b v from t_small z where z.a = y.a union all select 0 from db_root) u) order by 1;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ t_big.a, y.b from t_big, t_small y where t_big.a <= 10 and y.a = t_big.a and y.b >= (select max (u.v) from (select z.b v from t_small z where z.a = y.a union all select 0 from db_root) u) order by 1;


evaluate 'Case 6: hash join in an uncorrelated subquery; result = no_parallel_scan';
select /*+ recompile */ count(*) from t_big where b > (select /*+ use_hash */ max (z.b) from t_small z, t_small y where z.a = y.a);
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan */ count(*) from t_big where b > (select /*+ use_hash */ max (z.b) from t_small z, t_small y where z.a = y.a);


drop table t_big, t_small;
