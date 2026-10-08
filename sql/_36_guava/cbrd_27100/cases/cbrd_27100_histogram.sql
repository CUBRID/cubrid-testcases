/**
 *  This test case verifies CBRD-27100 with histograms: without a hint an index scan runs in
 *  parallel when every key-range term has a histogram estimate that clears the threshold.
 *
 *  The fix tags a term whose selectivity came from a histogram, and a no-hint index scan is
 *  parallel only when every term of its key range is tagged. This file uses the develop syntax:
 *  UPDATE STATISTICS builds the histograms (CBRD-26959), WITH DROP HISTOGRAM removes them.
 *
 *  Each query is followed by its parallel(0) twin, whose result must be the same. A parallel
 *  index scan prints a parallel workers line under its SCAN line; CTP masks the digits.
 *
 *  Coverage:
 *    Case 1:  a wide range with a histogram runs in parallel
 *    Case 2:  a narrow range with a histogram estimates under the threshold, serial
 *    Case 3:  a BETWEEN range with two constant bounds runs in parallel
 *    Case 4:  a BETWEEN range with a subquery as the lower or upper bound, serial
 *    Case 5:  an equality with a histogram runs in parallel
 *    Case 6:  an IN list of constants runs in parallel
 *    Case 7:  an IN list with a subquery as the first, middle or last element, serial
 *    Case 8:  three key-range terms, all with a histogram estimate, run in parallel
 *    Case 9:  the same with a subquery in the first term checked, serial
 *    Case 10: the same with a subquery in the middle term checked, serial
 *    Case 11: three terms with a narrower range on k, all estimated, run in parallel
 *    Case 12: case 11 with a subquery in the last term checked, serial
 *    Case 13: terms outside the key range need no histogram, the scan runs in parallel
 *    Case 14: a prepared range whose bound is a wide host variable runs in parallel
 *    Case 15: the same statement with a narrow host variable stays serial
 *    Case 16: after the histogram is dropped the wide range of case 1 stays serial
 *    Case 17: after the histogram is dropped the equality of case 5 stays serial
 */

drop table if exists t_big;

-- 150,000 rows, k = 1..150000, g = k mod 3, v = k mod 2, uniform; the 256-character pad (two sha2
-- strings, which do not compress) makes each index about 2,800 pages. The histogram estimates of the
-- parallel cases are at least 190 pages (6x the threshold of 32): k > 1000 0.99, g = 1 0.33,
-- g = 1 and v = 1 and k < 60000 0.33 x 0.5 x 0.4. The serial ones are under 6 pages (1/5) or rest
-- on a term without a histogram estimate. Terms are checked in order of selectivity: g, v, k for
-- k > 1000, and g, k, v for k < 60000
create table t_big (k int, g int, v int, pad varchar(256));
insert into t_big select rownum, mod(rownum, 3), mod(rownum, 2), concat(sha2(rownum, 512), sha2(-rownum, 512)) from db_class a, db_class b, db_class c, db_class d limit 150000;
create index i_big on t_big (k, pad);
create index i_multi on t_big (g, v, k, pad);

-- builds the statistics and a histogram on every column
update statistics on t_big with fullscan;

set trace on;


evaluate 'Case 1: a wide range with a histogram runs in parallel without a hint; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k > 1000 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k > 1000 using index i_big;


evaluate 'Case 2: a narrow range with a histogram is estimated under the threshold and stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k < 200 using index i_big;


evaluate 'Case 3: a BETWEEN range with two constant bounds runs in parallel; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k between 1000 and 150000 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k between 1000 and 150000 using index i_big;


evaluate 'Case 4: a BETWEEN range with a subquery as the lower or the upper bound stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k between (select 1000) and 150000 using index i_big;
show trace;
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k between 1000 and (select 150000) using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k between 1000 and 150000 using index i_big;


evaluate 'Case 5: an equality with a histogram runs in parallel; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = 1 using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = 1 using index i_multi;


evaluate 'Case 6: an IN list of constants runs in parallel; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g in (0, 1, 2) using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g in (0, 1, 2) using index i_multi;


evaluate 'Case 7: an IN list with a subquery as the first, middle or last element stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g in ((select 0), 1, 2) using index i_multi;
show trace;
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g in (0, (select 1), 2) using index i_multi;
show trace;
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g in (0, 1, (select 2)) using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g in (0, 1, 2) using index i_multi;


evaluate 'Case 8: three key-range terms all with a histogram estimate run in parallel; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = 1 and k > 1000 using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = 1 and k > 1000 using index i_multi;


evaluate 'Case 9: a subquery in the first term checked keeps the scan serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = (select 1) and v = 1 and k > 1000 using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = 1 and k > 1000 using index i_multi;


evaluate 'Case 10: a subquery in the middle term checked keeps the scan serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = (select 1) and k > 1000 using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = 1 and k > 1000 using index i_multi;


evaluate 'Case 11: three terms with a narrower range on k all with a histogram estimate run in parallel; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = 1 and k < 60000 using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = 1 and k < 60000 using index i_multi;


evaluate 'Case 12: a subquery in the last term checked keeps the scan serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = (select 1) and k < 60000 using index i_multi;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = 1 and v = 1 and k < 60000 using index i_multi;


evaluate 'Case 13: terms outside the key range need no histogram and the scan runs in parallel; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where v is not null and k > 1000 using index i_big;
show trace;
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k > 1000 and pad is not null using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k > 1000 using index i_big;


evaluate 'Case 14: a prepared range whose host variable makes it wide runs in parallel; result = parallel(0)';
prepare st from 'select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k > ? using index i_big';
execute st using 1000;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k > 1000 using index i_big;


evaluate 'Case 15: the same statement with a host variable that makes it narrow stays serial; result = parallel(0)';
execute st using 149900;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k > 149900 using index i_big;
deallocate prepare st;


evaluate 'Case 16: after the histogram is dropped the wide range of case 1 stays serial; result = parallel(0)';
update statistics on t_big with fullscan, drop histogram;
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where k > 1000 using index i_big;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where k > 1000 using index i_big;


evaluate 'Case 17: after the histogram is dropped the equality of case 5 stays serial; result = parallel(0)';
select /*+ recompile */ count(*), sum(cast(k as bigint)) from t_big where g = 1 using index i_multi;
show trace;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile parallel(0) */ count(*), sum(cast(k as bigint)) from t_big where g = 1 using index i_multi;


drop table t_big;
