/**
 *  This test case verifies CBRD-27728: a GROUP BY skip plan whose first GROUP BY column is DESC
 *  runs its index scan in parallel.
 *
 *  Before the fix the parallel check refused a GROUP BY skip when the first GROUP BY column was DESC
 *  (groupby_desc), whatever the scan direction: GROUP BY a DESC over an ascending index (read
 *  backwards) and GROUP BY a DESC over a descending index (read forwards) both ran serially.
 *
 *  Each tested query is followed by its twin with no_parallel_scan on every query block. The results
 *  must match. CTP masks digits: the proof is the parallel line under the index SCAN line and GROUPBY
 *  (no hash). Where order matters, rownum weighs every group by its position, so a group out of
 *  order changes the sum.
 *
 *  Coverage:
 *    Case 1: an ascending index read backwards for GROUP BY DESC, covered and not covered
 *    Case 2: two GROUP BY columns DESC over an ascending two-column index, the group order checked
 *    Case 3: a descending index read forwards for GROUP BY DESC, and read backwards for GROUP BY ASC
 *    Case 4: an index of mixed directions read backwards, GROUP BY a DESC, b
 *    Case 5: GROUP BY DESC over an IN list and over two ranges
 *    Case 6: NULL group keys with GROUP BY DESC
 *    Case 7: ORDER BY skip with a DESC key stays serial
 */

drop table if exists t_digit, t_main, t_dsc;

-- ten digits for the cross joins below
create table t_digit (i int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 200000 rows: g has 35 keys of 5714 or 5715 rows, h is NULL on every ninth row,
-- (g, v) has 7000 keys of 28 or 29 rows
create table t_main (id int primary key, g int not null, h int, v int, d double);
insert into t_main select rownum, mod(rownum, 35), case when mod(rownum, 9) = 0 then null else mod(rownum, 40) end, mod(rownum * 7, 1000), mod(rownum, 97) / 7.0 from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e, t_digit f limit 200000;
create index i_g on t_main (g);
create index i_hg on t_main (h, g);
create index i_gv on t_main (g, v);
-- the same (g, v) over a descending index and an index of mixed directions
create table t_dsc (a int not null, b int not null, c int);
insert into t_dsc select g, v, id from t_main;
create index i_dd on t_dsc (a desc, b desc);
create index i_ad on t_dsc (a, b desc);
update statistics on t_digit, t_main, t_dsc with fullscan;

set trace on;


evaluate 'Case 1: an ascending index read backwards for GROUP BY DESC, covered and not covered; result = no_parallel_scan';
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g >= 0 group by g desc;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main force index (i_g) where g >= 0 group by g desc;
select /*+ recompile */ g, count(*), sum(v), max(id), round(avg(d), 6) from t_main force index (i_g) where g >= 0 group by g desc;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v), max(id), round(avg(d), 6) from t_main force index (i_g) where g >= 0 group by g desc;


evaluate 'Case 2: two GROUP BY columns DESC over an ascending two-column index, the group order checked; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n), sum(r * (g * 1000 + v)) from (select rownum r, g, v, n from (select g, v, count(*) n from t_main force index (i_gv) where g >= 0 group by g desc, v desc) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (g * 1000 + v)) from (select /*+ no_parallel_scan */ rownum r, g, v, n from (select /*+ no_parallel_scan */ g, v, count(*) n from t_main force index (i_gv) where g >= 0 group by g desc, v desc) y) x;


evaluate 'Case 3: a descending index read forwards for GROUP BY DESC, and read backwards for GROUP BY ASC; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select rownum r, a, b, n from (select a, b, count(*) n from t_dsc force index (i_dd) where a >= 0 group by a desc, b desc) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select /*+ no_parallel_scan */ rownum r, a, b, n from (select /*+ no_parallel_scan */ a, b, count(*) n from t_dsc force index (i_dd) where a >= 0 group by a desc, b desc) y) x;
select /*+ recompile */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select rownum r, a, b, n from (select a, b, count(*) n from t_dsc force index (i_dd) where a >= 0 group by a, b) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select /*+ no_parallel_scan */ rownum r, a, b, n from (select /*+ no_parallel_scan */ a, b, count(*) n from t_dsc force index (i_dd) where a >= 0 group by a, b) y) x;


evaluate 'Case 4: an index of mixed directions read backwards, GROUP BY a DESC, b; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select rownum r, a, b, n from (select a, b, count(*) n from t_dsc force index (i_ad) where a >= 0 group by a desc, b) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select /*+ no_parallel_scan */ rownum r, a, b, n from (select /*+ no_parallel_scan */ a, b, count(*) n from t_dsc force index (i_ad) where a >= 0 group by a desc, b) y) x;


evaluate 'Case 5: GROUP BY DESC over an IN list and over two ranges; result = no_parallel_scan';
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g in (30, 2, 17, 9, 25, 11, 4, 33, 20, 6, 28, 14, 1, 22, 31, 8, 19, 26, 12, 3, 34, 15, 27, 5, 23) group by g desc;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v) from t_main force index (i_g) where g in (30, 2, 17, 9, 25, 11, 4, 33, 20, 6, 28, 14, 1, 22, 31, 8, 19, 26, 12, 3, 34, 15, 27, 5, 23) group by g desc;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 2 and 12 or g between 20 and 33 group by g desc;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v) from t_main force index (i_g) where g between 2 and 12 or g between 20 and 33 group by g desc;


evaluate 'Case 6: NULL group keys with GROUP BY DESC; result = no_parallel_scan';
select /*+ recompile */ h, count(*), sum(g) from t_main force index (i_hg) group by h desc;
show trace;
select /*+ recompile no_parallel_scan */ h, count(*), sum(g) from t_main force index (i_hg) group by h desc;
select /*+ recompile */ count(*), sum(n), sum(r * (nvl(h, 99) * 100 + g)) from (select rownum r, h, g, n from (select h, g, count(*) n from t_main force index (i_hg) group by h desc, g desc) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (nvl(h, 99) * 100 + g)) from (select /*+ no_parallel_scan */ rownum r, h, g, n from (select /*+ no_parallel_scan */ h, g, count(*) n from t_main force index (i_hg) group by h desc, g desc) y) x;


evaluate 'Case 7: ORDER BY skip with a DESC key stays serial; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(r * (g * 1000 + v)) from (select rownum r, g, v from (select g, v from t_main force index (i_gv) where g >= 0 order by g desc, v desc) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(r * (g * 1000 + v)) from (select /*+ no_parallel_scan */ rownum r, g, v from (select /*+ no_parallel_scan */ g, v from t_main force index (i_gv) where g >= 0 order by g desc, v desc) y) x;

set trace off;

drop table t_digit, t_main, t_dsc;
