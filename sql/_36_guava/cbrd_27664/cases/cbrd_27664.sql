/**
 *  This test case verifies CBRD-27664: a GROUP BY skip plan runs its index scan in parallel.
 *
 *  Before the fix a GROUP BY skip plan never ran its index scan in parallel. Now each worker
 *  aggregates the keys it reads, and the main thread merges the partial aggregates in key order.
 *
 *  Each tested query is followed by its twin with no_parallel_scan on every query block, or, in
 *  Cases 13 to 16, by the same query over the heap (IGNORE INDEX). The results must match. CTP
 *  masks digits: the proof is the parallel line under the index SCAN line and GROUPBY (no hash).
 *
 *  Coverage:
 *    Case 1:  covered scan over one range, over an IN list, and without aggregates
 *    Case 2:  non-covered scan, every combinable aggregate, data filters, a division by zero
 *    Case 3:  many groups: 7000 of two columns, 200000 of one, covered and not; the covered scan
 *             of 200000 groups (one row per group) stays serial, the non-covered one does not
 *    Case 4:  NULL group key on a two-column index without a range, one and both columns
 *    Case 5:  JSON_ARRAYAGG and JSON_OBJECTAGG, judged by their length
 *    Case 6:  a non-aggregated column in the select list, kept by the outer query (not covered)
 *    Case 7:  an analytic function, HAVING, HAVING with a correlated subquery, HAVING that fails
 *    Case 8:  ORDER BY an aggregate or the key descending, with LIMIT, inside a derived table
 *    Case 9:  a prefix of a two-column index, with a filter on the second column
 *    Case 10: three keys on long overflow chains that several workers read
 *    Case 11: COUNT DISTINCT, GROUP_CONCAT (with SEPARATOR), MEDIAN, PERCENTILE stay serial
 *    Case 12: an empty range, GROUP BY DESC and a small index stay serial
 *    Case 13: ORDER BY the key with LIMIT stops at the first, a middle, the last group and after
 *    Case 14: index_scan_in_oid_order keeps the index order of the scan (develop split groups)
 *    Case 15: a GROUP BY skip in a correlated subquery, run once for every outer row
 *    Case 16: a prefix index does not order the groups, so GROUP BY sorts (develop split groups)
 *    Case 17: an index with a DESC column: GROUP BY a, b DESC and GROUP BY a over (a DESC)
 *    Case 18: keys whose rows are all deleted, and a key whose first row is deleted
 *    Case 19: a case-insensitive string key, the leader merges a group's runs by the collation
 */

drop table if exists t_digit, t_main, t_few, t_small, t_pfx, t_dsc, t_ci;

-- ten digits for the cross joins below
create table t_digit (i int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 200000 rows: g has 35 keys of 5714 or 5715 rows (index i_g 353 pages, 11x the 32-page parallel
-- threshold under CTP), h is NULL on every ninth row (i_hg 331 pages), u is unique (i_u 209 pages),
-- (g, v) has 7000 keys of 28 or 29 rows (i_gv 113 pages, 3.5x). v = 7 only where id mod 1000 = 1
create table t_main (id int primary key, g int not null, h int, u int, v int, d double, s varchar(20));
insert into t_main select rownum, mod(rownum, 35), case when mod(rownum, 9) = 0 then null else mod(rownum, 40) end, rownum, mod(rownum * 7, 1000), mod(rownum, 97) / 7.0, 's' || mod(rownum, 13) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e, t_digit f limit 200000;
create index i_g on t_main (g);
create index i_hg on t_main (h, g);
create index i_u on t_main (u);
create index i_gv on t_main (g, v);
-- 100000 rows over 3 keys: every key keeps about 33000 objects on an overflow chain (i_k 155 pages, 4.8x)
create table t_few (id int primary key, k int not null, v int);
insert into t_few select rownum, mod(rownum, 3), mod(rownum * 13, 977) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e limit 100000;
create index i_k on t_few (k);
-- 100 rows: i_sv has 2 pages, 1/16 of the threshold
create table t_small (k int primary key, v int);
insert into t_small select id, v from t_main where id <= 100;
create index i_sv on t_small (v);
update statistics on t_digit, t_main, t_few, t_small with fullscan;

set trace on;


evaluate 'Case 1: covered scan over one range, over an IN list, and without aggregates; result = no_parallel_scan';
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33) group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main force index (i_g) where g in (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33) group by g order by g;
select /*+ recompile */ g from t_main force index (i_g) where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g from t_main force index (i_g) where g between 0 and 34 group by g order by g;


evaluate 'Case 2: non-covered scan with every combinable aggregate, data filters keeping some or no rows, a division by zero; result = no_parallel_scan';
select /*+ recompile */ g, count(*), count(h), sum(v), round(avg(v), 4), min(v), max(v), bit_or(v), bit_and(v), bit_xor(v), round(stddev(d), 6), round(var_samp(d), 6), round(stddev_pop(d), 6), round(var_pop(d), 6) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), count(h), sum(v), round(avg(v), 4), min(v), max(v), bit_or(v), bit_and(v), bit_xor(v), round(stddev(d), 6), round(var_samp(d), 6), round(stddev_pop(d), 6), round(var_pop(d), 6) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 and mod(v, 3) = 0 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 and mod(v, 3) = 0 group by g order by g;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 and v < 0 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 and v < 0 group by g order by g;
select /*+ recompile */ g, sum(100 / (v - 7)) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, sum(100 / (v - 7)) from t_main force index (i_g) where g between 0 and 34 group by g order by g;


evaluate 'Case 3: many groups, 7000 of two columns, 200000 of one, covered and not; result = no_parallel_scan';
select /*+ recompile */ count(*), sum(c), min(c), max(c), sum(c * (g * 1000 + v)) from (select g, v, count(*) c from t_main force index (i_gv) where g >= 0 group by g, v) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(c), min(c), max(c), sum(c * (g * 1000 + v)) from (select /*+ no_parallel_scan */ g, v, count(*) c from t_main force index (i_gv) where g >= 0 group by g, v) x;
select /*+ recompile */ count(*), sum(c), min(u), max(u) from (select u, count(*) c from t_main where u > 0 group by u) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(c), min(u), max(u) from (select /*+ no_parallel_scan */ u, count(*) c from t_main where u > 0 group by u) x;
select /*+ recompile */ count(*), sum(c), sum(w), min(u), max(u) from (select u, count(*) c, sum(v) w from t_main force index (i_u) where u > 0 group by u) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(w), min(u), max(u) from (select /*+ no_parallel_scan */ u, count(*) c, sum(v) w from t_main force index (i_u) where u > 0 group by u) x;


evaluate 'Case 4: NULL group key on a two-column index without a range, one and both columns; result = no_parallel_scan';
select /*+ recompile */ h, count(*), sum(v) from t_main force index (i_hg) group by h order by h;
show trace;
select /*+ recompile no_parallel_scan */ h, count(*), sum(v) from t_main force index (i_hg) group by h order by h;
select /*+ recompile */ count(*), sum(c), sum(c * (nvl(h, 99) * 100 + g)) from (select h, g, count(*) c from t_main force index (i_hg) group by h, g) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(c), sum(c * (nvl(h, 99) * 100 + g)) from (select /*+ no_parallel_scan */ h, g, count(*) c from t_main force index (i_hg) group by h, g) x;


evaluate 'Case 5: JSON_ARRAYAGG and JSON_OBJECTAGG, judged by their length; result = no_parallel_scan';
select /*+ recompile */ k, json_length(json_arrayagg(id)), sum(id), json_length(json_objectagg(id, v)) from t_few force index (i_k) where k >= 0 group by k order by k;
show trace;
select /*+ recompile no_parallel_scan */ k, json_length(json_arrayagg(id)), sum(id), json_length(json_objectagg(id, v)) from t_few force index (i_k) where k >= 0 group by k order by k;


evaluate 'Case 6: a non-aggregated column in the select list, kept by the outer query (not covered); result = no_parallel_scan';
-- s is read but not printed: which row of the group gives it depends on the read order. Selecting
-- s is not null keeps s in the derived table, so the scan reads the heap (not covered)
select /*+ recompile */ g, c, s is not null from (select g, s, count(*) c from t_main force index (i_g) where g between 0 and 34 group by g) z order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, c, s is not null from (select /*+ no_parallel_scan */ g, s, count(*) c from t_main force index (i_g) where g between 0 and 34 group by g) z order by g;


evaluate 'Case 7: an analytic function, HAVING, HAVING with a correlated subquery, HAVING that fails; result = no_parallel_scan';
select /*+ recompile */ g, count(*), lag(count(*), 1, 0) over (order by g) from t_main where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), lag(count(*), 1, 0) over (order by g) from t_main where g between 0 and 34 group by g order by g;
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g having sum(v) > 2850000 order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g having sum(v) > 2850000 order by g;
select /*+ recompile */ g, count(*) from t_main where g between 0 and 34 group by g having count(*) > (select count(*) from t_small where t_small.v = t_main.g) * 5714 order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main where g between 0 and 34 group by g having count(*) > (select /*+ no_parallel_scan */ count(*) from t_small where t_small.v = t_main.g) * 5714 order by g;
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g having count(*) / (g - 5) > 0 order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g having count(*) / (g - 5) > 0 order by g;


evaluate 'Case 8: ORDER BY an aggregate or the key descending, with LIMIT, inside a derived table; result = no_parallel_scan';
select /*+ recompile */ g, count(*) from t_main where g between 0 and 34 group by g order by count(*) desc, g limit 1;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main where g between 0 and 34 group by g order by count(*) desc, g limit 1;
select /*+ recompile */ g, sum(v) from t_main where g between 0 and 34 group by g order by sum(v) desc, g;
show trace;
select /*+ recompile no_parallel_scan */ g, sum(v) from t_main where g between 0 and 34 group by g order by sum(v) desc, g;
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g desc;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g desc;
select /*+ recompile */ median(g) from (select g from t_main where g >= 0 group by g order by count(*) desc, g limit 1) x;
show trace;
select /*+ recompile no_parallel_scan */ median(g) from (select /*+ no_parallel_scan */ g from t_main where g >= 0 group by g order by count(*) desc, g limit 1) x;


evaluate 'Case 9: a prefix of a two-column index, with a filter on the second column; result = no_parallel_scan';
select /*+ recompile */ g, count(*), sum(v), min(v), max(v) from t_main force index (i_gv) where g >= 0 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v), min(v), max(v) from t_main force index (i_gv) where g >= 0 group by g order by g;
select /*+ recompile */ g, count(*), min(v) from t_main force index (i_gv) where g >= 0 and v > 500 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), min(v) from t_main force index (i_gv) where g >= 0 and v > 500 group by g order by g;


evaluate 'Case 10: three keys on long overflow chains that several workers read; result = no_parallel_scan';
select /*+ recompile */ k, count(*), sum(v), min(v), max(v), round(avg(v), 4) from t_few force index (i_k) where k >= 0 group by k order by k;
show trace;
select /*+ recompile no_parallel_scan */ k, count(*), sum(v), min(v), max(v), round(avg(v), 4) from t_few force index (i_k) where k >= 0 group by k order by k;
select /*+ recompile */ k, count(*) from t_few where k >= 0 group by k order by k;
show trace;
select /*+ recompile no_parallel_scan */ k, count(*) from t_few where k >= 0 group by k order by k;


evaluate 'Case 11: COUNT DISTINCT, GROUP_CONCAT (with SEPARATOR), MEDIAN and PERCENTILE stay serial; result = no_parallel_scan';
select /*+ recompile */ g, count(distinct v) from t_main where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(distinct v) from t_main where g between 0 and 34 group by g order by g;
select /*+ recompile */ k, group_concat(distinct mod(v, 7) order by 1) from t_few force index (i_k) where k >= 0 group by k order by k;
show trace;
select /*+ recompile no_parallel_scan */ k, group_concat(distinct mod(v, 7) order by 1) from t_few force index (i_k) where k >= 0 group by k order by k;
-- a SEPARATOR is no column of the scan: an int and a string operand, groups small enough to print
select /*+ recompile */ k, group_concat(v order by v desc separator '|') from t_few force index (i_k) where k >= 0 and id <= 30 group by k order by k;
show trace;
select /*+ recompile no_parallel_scan */ k, group_concat(v order by v desc separator '|') from t_few force index (i_k) where k >= 0 and id <= 30 group by k order by k;
select /*+ recompile */ g, group_concat(s order by s separator ', ') from t_main force index (i_g) where g between 0 and 34 and id <= 70 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, group_concat(s order by s separator ', ') from t_main force index (i_g) where g between 0 and 34 and id <= 70 group by g order by g;
select /*+ recompile */ k, median(v) from t_few force index (i_k) where k >= 0 group by k order by k;
show trace;
select /*+ recompile no_parallel_scan */ k, median(v) from t_few force index (i_k) where k >= 0 group by k order by k;
-- a PERCENTILE argument that is no constant (here from the group key) is read from the scan too
select /*+ recompile */ g, round(percentile_cont(g / 100.0) within group (order by v), 4), percentile_disc(g / 100.0) within group (order by v) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, round(percentile_cont(g / 100.0) within group (order by v), 4), percentile_disc(g / 100.0) within group (order by v) from t_main force index (i_g) where g between 0 and 34 group by g order by g;


evaluate 'Case 12: an empty range, GROUP BY DESC and a small index stay serial; result = no_parallel_scan';
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 100 and 200 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v) from t_main force index (i_g) where g between 100 and 200 group by g order by g;
select /*+ recompile */ g, count(*) from t_main where g between 0 and 34 group by g desc order by g desc;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main where g between 0 and 34 group by g desc order by g desc;
select /*+ recompile */ v, count(*) from t_small where v >= 0 group by v order by v;
show trace;
select /*+ recompile no_parallel_scan */ v, count(*) from t_small where v >= 0 group by v order by v;


evaluate 'Case 13: ORDER BY the key with LIMIT stops at the first, a middle, the last group and after; result = IGNORE INDEX';
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g limit 1;
show trace;
select /*+ recompile */ g, count(*) from t_main ignore index (i_g, i_gv) where g between 0 and 34 group by g order by g limit 1;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by g limit 2, 2;
show trace;
select /*+ recompile */ g, count(*), sum(v) from t_main ignore index (i_g, i_gv) where g between 0 and 34 group by g order by g limit 2, 2;
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g limit 35;
show trace;
select /*+ recompile */ g, count(*) from t_main ignore index (i_g, i_gv) where g between 0 and 34 group by g order by g limit 35;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by g limit 36;
show trace;
select /*+ recompile */ g, count(*), sum(v) from t_main ignore index (i_g, i_gv) where g between 0 and 34 group by g order by g limit 36;
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g having groupby_num () between 2 and 3 order by g;
show trace;
select /*+ recompile */ g, count(*) from t_main ignore index (i_g, i_gv) where g between 0 and 34 group by g having groupby_num () between 2 and 3 order by g;


evaluate 'Case 14: index_scan_in_oid_order keeps the index order of a GROUP BY skip scan; result = IGNORE INDEX';
set system parameters 'index_scan_in_oid_order=yes';
select /*+ recompile no_parallel_scan */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by count(*), g;
show trace;
select /*+ recompile */ g, count(*), sum(v) from t_main ignore index (i_g, i_gv) where g between 0 and 34 group by g order by count(*), g;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by count(*), g;
show trace;
select /*+ recompile */ g, count(*), sum(v) from t_main ignore index (i_g, i_gv) where g between 0 and 34 group by g order by count(*), g;
set system parameters 'index_scan_in_oid_order=default';


evaluate 'Case 15: a GROUP BY skip in a correlated subquery, run once for every outer row; result = IGNORE INDEX';
select /*+ recompile */ k, (select sum(v) from t_main force index (i_g) where g between t_small.k and t_small.k + 3 group by g order by sum(v) desc, g limit 1) from t_small where k <= 40 order by k;
show trace;
select /*+ recompile */ k, (select sum(v) from t_main ignore index (i_g, i_gv) where g between t_small.k and t_small.k + 3 group by g order by sum(v) desc, g limit 1) from t_small where k <= 40 order by k;


evaluate 'Case 16: a prefix index does not order the groups, so GROUP BY sorts; result = IGNORE INDEX';
-- every s shares the 3-character prefix: i_p holds one key for the 7 groups
create table t_pfx (s varchar(20) not null, x int);
insert into t_pfx select 'abc' || mod(id, 7), id from t_main where id <= 1000;
create index i_p on t_pfx (s(3));
update statistics on t_pfx with fullscan;
select /*+ recompile */ s, count(*), sum(x) from t_pfx where s > '' group by s order by s;
show trace;
select /*+ recompile */ s, count(*), sum(x) from t_pfx ignore index (i_p) where s > '' group by s order by s;


evaluate 'Case 17: an index with a DESC column, GROUP BY a, b DESC over (a, b DESC) and GROUP BY a over (a DESC); result = no_parallel_scan';
-- 100000 rows of t_main: (a, b) has 7000 keys (i_ab 113 pages, 3.5x), a has 35 keys on overflow
-- chains (i_ad 213 pages, 6.6x). The ascending GROUP BY reads i_ad backwards
create table t_dsc (a int not null, b int not null, c int);
insert into t_dsc select g, v, id from t_main where id <= 100000;
create index i_ab on t_dsc (a, b desc);
create index i_ad on t_dsc (a desc);
update statistics on t_dsc with fullscan;
-- rownum weighs every group by its position, so a group out of order changes the sum
select /*+ recompile */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select rownum r, a, b, n from (select a, b, count(*) n from t_dsc force index (i_ab) where a >= 0 group by a, b desc order by a, b desc) y) x;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(n), sum(r * (a * 1000 + b)) from (select /*+ no_parallel_scan */ rownum r, a, b, n from (select /*+ no_parallel_scan */ a, b, count(*) n from t_dsc force index (i_ab) where a >= 0 group by a, b desc order by a, b desc) y) x;
select /*+ recompile */ a, count(*), sum(c) from t_dsc force index (i_ad) where a >= 0 group by a order by a;
show trace;
select /*+ recompile no_parallel_scan */ a, count(*), sum(c) from t_dsc force index (i_ad) where a >= 0 group by a order by a;
select /*+ recompile */ a, count(*) from t_dsc force index (i_ad) where a >= 0 group by a order by a;
show trace;
select /*+ recompile no_parallel_scan */ a, count(*) from t_dsc force index (i_ad) where a >= 0 group by a order by a;


evaluate 'Case 18: keys whose rows are all deleted, and a key whose first row is deleted; result = no_parallel_scan';
delete from t_main where g in (3, 4, 20) or id = 5;
select /*+ recompile */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*), sum(v) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
select /*+ recompile */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g;
show trace;
select /*+ recompile no_parallel_scan */ g, count(*) from t_main force index (i_g) where g between 0 and 34 group by g order by g;


evaluate 'Case 19: a case-insensitive string key whose groups several workers read; result = no_parallel_scan';
-- 200000 rows: k has 40 groups of 5000 rows in three spellings (Grp1, gRP1, GRP1), one key each under
-- utf8_en_ci with a long overflow chain. The leader must merge the runs of a group by the collation.
-- The printed key is lower(k): its spelling comes from whichever run is merged first
create table t_ci (id int primary key, k varchar(20) collate utf8_en_ci not null, v int);
insert into t_ci select rownum, decode(mod(rownum, 3), 0, 'Grp', 1, 'gRP', 'GRP') || mod(rownum, 40), mod(rownum * 7, 1000) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e, t_digit f limit 200000;
create index i_ci on t_ci (k);
update statistics on t_ci with fullscan;
select /*+ recompile */ lower(x.k), x.c, x.s from (select k, count(*) c, sum(v) s from t_ci force index (i_ci) where k > '' group by k) x order by 1;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan */ lower(x.k), x.c, x.s from (select /*+ no_parallel_scan */ k, count(*) c, sum(v) s from t_ci force index (i_ci) where k > '' group by k) x order by 1;

drop table t_digit, t_main, t_few, t_small, t_pfx, t_dsc, t_ci;
