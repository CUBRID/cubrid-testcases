/**
 *  This test case verifies CBRD-27468: GROUP BY ... WITH ROLLUP takes the GROUP BY skip plan.
 *
 *  Before the fix a query with WITH ROLLUP never skipped its GROUP BY, even over an index in the
 *  GROUP BY order: it scanned the heap and sorted (or hashed) the groups. Now the index scan hands
 *  the groups over in order and the subtotals are made as the groups end, serially or by the main
 *  thread while it merges the partial aggregates of a parallel scan.
 *
 *  Each tested query is followed by its twin over the heap (IGNORE INDEX), which sorts or hashes
 *  the groups as before. The results, the subtotal rows and their order included, must match.
 *  CTP masks digits: the proof is the index SCAN line and GROUPBY (sort: false) in the trace, and
 *  the parallel line under the SCAN line where the scan runs in parallel.
 *
 *  Coverage:
 *    Case 1:  two keys, covered: parallel, and serial with no_parallel_scan
 *    Case 2:  two keys, not covered: parallel
 *    Case 3:  one key, and three keys over a range
 *    Case 4:  NULL group keys: the NULL group of a key and its subtotal are different rows
 *    Case 5:  HAVING, and ORDER BY over the subtotals
 *    Case 6:  COUNT DISTINCT, GROUP_CONCAT and MEDIAN, which aggregate serially
 *    Case 7:  an empty range, and the range of one key of g
 *    Case 8:  GROUP BY DESC with ROLLUP and a GROUP BY order the index does not have still sort
 */

drop table if exists t_digit, t_roll;

-- ten digits for the cross joins below
create table t_digit (i int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 200000 rows: g has 35 keys, (g, v) 105 keys of about 1900 rows. h is NULL on every ninth row and
-- has 5 other values. x has 3 values. The indexes are above the parallel threshold under CTP.
create table t_roll (id int primary key, g int not null, v int not null, h int, x int not null, w int, s varchar(20));
insert into t_roll select rownum, mod(rownum, 35), mod(rownum, 3), case when mod(rownum, 9) = 0 then null else mod(rownum, 5) end, mod(rownum, 11) / 4, mod(rownum * 7, 1000), 's' || mod(rownum, 13) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e, t_digit f limit 200000;
create index i_gv on t_roll (g, v);
create index i_gvx on t_roll (g, v, x);
create index i_hg on t_roll (h, g);
update statistics on t_digit, t_roll with fullscan;

set trace on;


evaluate 'Case 1: two keys, covered, parallel and serial; result = IGNORE INDEX';
select /*+ recompile */ g, v, count(*), sum(v), max(v) from t_roll force index (i_gv) where g >= 0 group by g, v with rollup;
show trace;
select /*+ recompile no_parallel_scan */ g, v, count(*), sum(v), max(v) from t_roll force index (i_gv) where g >= 0 group by g, v with rollup;
show trace;
select /*+ recompile */ g, v, count(*), sum(v), max(v) from t_roll ignore index (i_gv, i_gvx, i_hg) where g >= 0 group by g, v with rollup;


evaluate 'Case 2: two keys, not covered, parallel; result = IGNORE INDEX';
select /*+ recompile */ g, v, count(*), sum(w), min(w), max(s), round(avg(w), 4) from t_roll force index (i_gv) where g >= 0 group by g, v with rollup;
show trace;
select /*+ recompile */ g, v, count(*), sum(w), min(w), max(s), round(avg(w), 4) from t_roll ignore index (i_gv, i_gvx, i_hg) where g >= 0 group by g, v with rollup;


evaluate 'Case 3: one key, and three keys over a range; result = IGNORE INDEX';
select /*+ recompile */ g, count(*), sum(v) from t_roll force index (i_gv) where g >= 0 group by g with rollup;
show trace;
select /*+ recompile */ g, count(*), sum(v) from t_roll ignore index (i_gv, i_gvx, i_hg) where g >= 0 group by g with rollup;
select /*+ recompile */ g, v, x, count(*), sum(x) from t_roll force index (i_gvx) where g between 3 and 5 group by g, v, x with rollup;
show trace;
select /*+ recompile */ g, v, x, count(*), sum(x) from t_roll ignore index (i_gv, i_gvx, i_hg) where g between 3 and 5 group by g, v, x with rollup;


evaluate 'Case 4: NULL group keys of h next to their subtotals; result = IGNORE INDEX';
select /*+ recompile */ h, g, count(*) from t_roll force index (i_hg) where g < 3 group by h, g with rollup;
show trace;
select /*+ recompile */ h, g, count(*) from t_roll ignore index (i_gv, i_gvx, i_hg) where g < 3 group by h, g with rollup;


evaluate 'Case 5: HAVING, and ORDER BY over the subtotals; result = IGNORE INDEX';
select /*+ recompile */ g, v, count(*) from t_roll force index (i_gv) where g >= 0 group by g, v with rollup having count(*) > 1904 or g is null;
show trace;
select /*+ recompile */ g, v, count(*) from t_roll ignore index (i_gv, i_gvx, i_hg) where g >= 0 group by g, v with rollup having count(*) > 1904 or g is null;
select /*+ recompile */ g, v, count(*) from t_roll force index (i_gv) where g between 10 and 12 group by g, v with rollup order by g desc, v;
show trace;
select /*+ recompile */ g, v, count(*) from t_roll ignore index (i_gv, i_gvx, i_hg) where g between 10 and 12 group by g, v with rollup order by g desc, v;


evaluate 'Case 6: COUNT DISTINCT, GROUP_CONCAT and MEDIAN aggregate serially; result = IGNORE INDEX';
select /*+ recompile */ g, v, count(distinct w), median(w), length(group_concat(w order by w separator ',')) from t_roll force index (i_gv) where g between 0 and 6 group by g, v with rollup;
show trace;
select /*+ recompile */ g, v, count(distinct w), median(w), length(group_concat(w order by w separator ',')) from t_roll ignore index (i_gv, i_gvx, i_hg) where g between 0 and 6 group by g, v with rollup;


evaluate 'Case 7: an empty range, and the range of one key of g; result = IGNORE INDEX';
select /*+ recompile */ g, v, count(*) from t_roll force index (i_gv) where g = 99 group by g, v with rollup;
show trace;
select /*+ recompile */ g, v, count(*) from t_roll ignore index (i_gv, i_gvx, i_hg) where g = 99 group by g, v with rollup;
select /*+ recompile */ g, v, count(*) from t_roll force index (i_gv) where g = 7 and v < 2 group by g, v with rollup;
show trace;
select /*+ recompile */ g, v, count(*) from t_roll ignore index (i_gv, i_gvx, i_hg) where g = 7 and v < 2 group by g, v with rollup;


evaluate 'Case 8: GROUP BY DESC with ROLLUP and a GROUP BY order the index does not have sort the groups';
select /*+ recompile */ g, v, count(*) from t_roll force index (i_gv) where g between 30 and 31 group by g desc, v desc with rollup;
show trace;
select /*+ recompile */ v, g, count(*) from t_roll force index (i_gv) where g between 30 and 31 group by v, g with rollup;
show trace;


set trace off;
drop table t_digit, t_roll;
