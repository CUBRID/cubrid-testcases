/**
 *  This test case verifies the key range part of the CBRD-27593 fix: a parallel index scan in
 *  descending order reads every row once when OR ranges bound by host variables overlap.
 *
 *  Before the fix a parallel scan of a descending index, or of an ascending index under
 *  USE_DESC_IDX, reversed every range before it merged the ranges, so overlapping ranges looked
 *  disjoint and the rows of the overlap came back twice. The client merges overlapping constant
 *  ranges before the plan, so only ranges with host variables reach the server overlapping.
 *
 *  A parallel index scan prints a parallel workers line under its SCAN line. CTP masks the
 *  digits, so only the line is asserted. Each execution is followed by its no_parallel_scan twin
 *  with the same values. Every e is unique, so count(*) must equal count(distinct e).
 *
 *  Coverage:
 *    Case 1:  a descending index, two overlapping ranges, the reported query
 *    Case 2:  a descending index, one range inside another
 *    Case 3:  a descending index, a constant range and an overlapping host-variable range
 *    Case 4:  an ascending index under USE_DESC_IDX, two overlapping ranges
 *    Case 5:  a descending index, three ranges of which two overlap, and three disjoint ranges
 *    Case 6:  an ascending index in ascending order, two overlapping ranges (also right before the fix)
 */

drop table if exists n_digit, t_desc;

-- ten digits to build 200,000 rows by a cross join
create table n_digit (i int);
insert into n_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 200,000 rows with e = id: i_ed and i_ea hold about 200 pages each, 6x the 32 pages a hinted
-- parallel index scan needs under CTP
create table t_desc (id int, e int);
insert into t_desc select rownum, rownum from n_digit n_a, n_digit n_b, n_digit n_c, n_digit n_d, n_digit n_e, n_digit n_f limit 200000;
create index i_ed on t_desc (e desc);
create index i_ea on t_desc (id);
update statistics on n_digit, t_desc with fullscan;

set trace on;


evaluate 'Case 1: a descending index with two overlapping host-variable ranges reads each row once; result = no_parallel_scan';
prepare st_par from 'select /*+ recompile parallel(4) */ count(*), count(distinct e), min(e), max(e) from t_desc where (e between ? and ? or e between ? and ?) using index i_ed';
prepare st_ser from 'select /*+ recompile no_parallel_scan */ count(*), count(distinct e), min(e), max(e) from t_desc where (e between ? and ? or e between ? and ?) using index i_ed';
execute st_par using 10, 1000, 500, 3000;
show trace;
execute st_ser using 10, 1000, 500, 3000;


evaluate 'Case 2: a descending index with one host-variable range inside another; result = no_parallel_scan';
execute st_par using 10, 3000, 500, 1000;
show trace;
execute st_ser using 10, 3000, 500, 1000;
deallocate prepare st_par;
deallocate prepare st_ser;


evaluate 'Case 3: a descending index with a constant range and an overlapping host-variable range; result = no_parallel_scan';
prepare st_par from 'select /*+ recompile parallel(4) */ count(*), count(distinct e), min(e), max(e) from t_desc where (e between 10 and 1000 or e between ? and ?) using index i_ed';
prepare st_ser from 'select /*+ recompile no_parallel_scan */ count(*), count(distinct e), min(e), max(e) from t_desc where (e between 10 and 1000 or e between ? and ?) using index i_ed';
execute st_par using 500, 3000;
show trace;
execute st_ser using 500, 3000;
deallocate prepare st_par;
deallocate prepare st_ser;


evaluate 'Case 4: an ascending index under USE_DESC_IDX with two overlapping host-variable ranges; result = no_parallel_scan';
prepare st_par from 'select /*+ recompile parallel(4) use_desc_idx */ count(*), count(distinct id), min(id), max(id) from t_desc where (id between ? and ? or id between ? and ?) using index i_ea';
prepare st_ser from 'select /*+ recompile no_parallel_scan use_desc_idx */ count(*), count(distinct id), min(id), max(id) from t_desc where (id between ? and ? or id between ? and ?) using index i_ea';
execute st_par using 10, 1000, 500, 3000;
show trace;
execute st_ser using 10, 1000, 500, 3000;
deallocate prepare st_par;
deallocate prepare st_ser;


evaluate 'Case 5: a descending index with three ranges of which two overlap, and with three disjoint ranges; result = no_parallel_scan';
prepare st_par from 'select /*+ recompile parallel(4) */ count(*), count(distinct e), min(e), max(e) from t_desc where (e between ? and ? or e between ? and ? or e between ? and ?) using index i_ed';
prepare st_ser from 'select /*+ recompile no_parallel_scan */ count(*), count(distinct e), min(e), max(e) from t_desc where (e between ? and ? or e between ? and ? or e between ? and ?) using index i_ed';
execute st_par using 5000, 6000, 10, 1000, 500, 3000;
show trace;
execute st_ser using 5000, 6000, 10, 1000, 500, 3000;
execute st_par using 10, 400, 500, 3000, 150000, 150010;
show trace;
execute st_ser using 10, 400, 500, 3000, 150000, 150010;
deallocate prepare st_par;
deallocate prepare st_ser;


evaluate 'Case 6: an ascending index in ascending order with two overlapping host-variable ranges; result = no_parallel_scan';
prepare st_par from 'select /*+ recompile parallel(4) */ count(*), count(distinct id), min(id), max(id) from t_desc where (id between ? and ? or id between ? and ?) using index i_ea';
prepare st_ser from 'select /*+ recompile no_parallel_scan */ count(*), count(distinct id), min(id), max(id) from t_desc where (id between ? and ? or id between ? and ?) using index i_ea';
execute st_par using 10, 1000, 500, 3000;
show trace;
execute st_ser using 10, 1000, 500, 3000;
deallocate prepare st_par;
deallocate prepare st_ser;
-- the next case of the shard starts with trace off
set trace off;


drop table n_digit, t_desc;
