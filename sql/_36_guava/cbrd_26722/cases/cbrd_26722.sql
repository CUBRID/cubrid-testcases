/**
 *  This test case verifies CBRD-26722: the NO_PARALLEL_SCAN hint and the scan checker that now
 *  decide whether a heap, list or index scan runs in parallel.
 *
 *  Before the fix the hint was NO_PARALLEL_HEAP_SCAN and covered heap scans only. The fix renames
 *  it, applies it to heap, list and index scans of its own query block, renames the page threshold
 *  parameter, and changes which joined or nested blocks keep the driving heap scan serial.
 *
 *  A parallel scan prints a parallel workers line under its SCAN line; CTP masks the digits, so
 *  only the line and its gather token are asserted. Every result is compared with the same query
 *  under another hint or with parallel(0). Case 9 and 10 compare results only, their plans differ
 *  between builds.
 *
 *  Coverage:
 *    Case 1:  NO_PARALLEL_SCAN keeps a heap scan and a driving heap of a join serial
 *    Case 2:  the old NO_PARALLEL_HEAP_SCAN spelling is ignored, the heap scan stays parallel
 *    Case 3:  the hint covers its own block only: outer list scan, inner heap scan, both
 *    Case 4:  PARALLEL(2) opens a list scan in parallel, PARALLEL(1) and PARALLEL(0) do not
 *    Case 5:  a view keeps NO_PARALLEL_SCAN in its text and its heap scan stays serial
 *    Case 6:  the old threshold parameter is unknown, the two new ones cannot be set by SET
 *    Case 7:  an uncorrelated derived table beside the driving heap keeps the buildvalue gather
 *    Case 8:  a session variable in any joined table keeps the driving heap scan serial
 *    Case 9:  a correlated derived table beside the driving heap joins every row
 *    Case 10: correlated subqueries on the inner table and an inner table with no used column
 */

drop table if exists t_heap, t_small, t_mid, t_tri;

-- 100,000 rows of 168 bytes (a 128-character sha2 string that does not compress): 1,177 heap pages,
-- 36x the scan threshold of 32 pages under CTP, and a derived table over it is a list of similar size;
-- g puts 1, 2, 4, 8, 16 and 32 of every 63 rows into groups 0 to 5, so every group has a different count
create table t_heap (id int, g int, v int, pad varchar(128));
insert into t_heap select rownum, case when mod(rownum, 63) < 1 then 0 when mod(rownum, 63) < 3 then 1 when mod(rownum, 63) < 7 then 2 when mod(rownum, 63) < 15 then 3 when mod(rownum, 63) < 31 then 4 else 5 end, mod(rownum, 1000), sha2(rownum, 512) from db_class a, db_class b, db_class c, db_class d limit 100000;
-- one join partner per group
create table t_small (g int, k int);
insert into t_small values (0, 10), (1, 20), (2, 30), (3, 40), (4, 50), (5, 60);
-- ten rows per group
create table t_mid (g int, k int);
insert into t_mid select mod(rownum, 6), rownum from db_class a limit 60;
-- ten rows per group with w = 0, 1, 2
create table t_tri (g int, w int);
insert into t_tri select mod(rownum, 6), mod(rownum, 3) from db_class a limit 60;
update statistics on t_heap, t_small, t_mid, t_tri with fullscan;

set trace on;


evaluate 'Case 1: NO_PARALLEL_SCAN keeps a heap scan serial; result = the query without the hint';
select /*+ recompile no_parallel_scan */ count(*), sum(v), min(id), max(id) from t_heap;
show trace;
select /*+ recompile */ count(*), sum(v), min(id), max(id) from t_heap;
show trace;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(s.k) from t_heap t, t_small s where t.g = s.g;
show trace;
select /*+ recompile ordered use_nl */ count(*), sum(s.k) from t_heap t, t_small s where t.g = s.g;
show trace;


evaluate 'Case 2: the old NO_PARALLEL_HEAP_SCAN spelling is not a hint any more and the heap scan stays parallel; result = Case 1';
select /*+ recompile no_parallel_heap_scan */ count(*), sum(v), min(id), max(id) from t_heap;
show trace;
select /*+ recompile NO_PARALLEL_SCAN */ count(*), sum(v), min(id), max(id) from t_heap;
show trace;


evaluate 'Case 3: the hint covers the scans of its own query block only; result = Case 1';
select /*+ recompile no_parallel_scan */ count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile */ count(*), sum(d.v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile no_parallel_scan */ count(*), sum(d.v) from (select /*+ no_merge no_parallel_scan */ id, g, v, pad from t_heap) d;
show trace;


evaluate 'Case 4: PARALLEL(2) opens the list scan in parallel, PARALLEL(1) and PARALLEL(0) keep it serial; result = Case 1';
select /*+ recompile parallel(2) */ count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile parallel(1) */ count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;
select /*+ recompile parallel(0) */ count(*), sum(d.v) from (select /*+ no_merge */ id, g, v, pad from t_heap) d;
show trace;


evaluate 'Case 5: a view keeps NO_PARALLEL_SCAN in its text and a query over it scans the heap serially; result = Case 1';
create view v_noparallel as select /*+ no_parallel_scan */ id, v from t_heap;
show create view v_noparallel;
select /*+ recompile */ count(*), sum(v) from v_noparallel;
show trace;
drop view v_noparallel;


-- these SET statements fail by design, so no parameter needs a restore
evaluate 'Case 6: parallel_heap_scan_page_threshold is unknown, the two new thresholds exist but SET cannot change them';
set system parameters 'parallel_heap_scan_page_threshold=32';
set system parameters 'parallel_scan_page_threshold=32';
set system parameters 'parallel_index_scan_page_threshold=32';


evaluate 'Case 7: an uncorrelated derived table beside the driving heap keeps the buildvalue gather; result = parallel(0)';
select /*+ recompile ordered use_nl */ count(*), sum(t.v) from t_heap t, (select /*+ no_merge */ g from t_mid where k > 54) d where t.g = d.g;
show trace;
select /*+ recompile ordered use_nl parallel(0) */ count(*), sum(t.v) from t_heap t, (select /*+ no_merge */ g from t_mid where k > 54) d where t.g = d.g;
select /*+ recompile ordered use_nl */ count(*), sum(t.v) from t_heap t, (select distinct g from t_mid) d where t.g = d.g;
show trace;
select /*+ recompile ordered use_nl parallel(0) */ count(*), sum(t.v) from t_heap t, (select distinct g from t_mid) d where t.g = d.g;


evaluate 'Case 8: a session variable in the term of the second, third or last joined table keeps the driving heap serial; result = parallel(0)';
set @pv = 1;
select /*+ recompile ordered use_nl */ count(*) from t_heap t, t_tri u, t_small s where t.g = u.g and u.g = s.g and u.w = @pv;
show trace;
select /*+ recompile ordered use_nl parallel(0) */ count(*) from t_heap t, t_tri u, t_small s where t.g = u.g and u.g = s.g and u.w = @pv;
select /*+ recompile ordered use_nl */ count(*) from t_heap t, t_small s, t_tri u where t.g = s.g and s.g = u.g and u.w = @pv;
show trace;
select /*+ recompile ordered use_nl parallel(0) */ count(*) from t_heap t, t_small s, t_tri u where t.g = s.g and s.g = u.g and u.w = @pv;
select /*+ recompile ordered use_nl */ count(*) from t_heap t, t_small s, t_tri u, t_small x where t.g = s.g and s.g = u.g and u.g = x.g and u.w = @pv;
show trace;
select /*+ recompile ordered use_nl parallel(0) */ count(*) from t_heap t, t_small s, t_tri u, t_small x where t.g = s.g and s.g = u.g and u.g = x.g and u.w = @pv;
select /*+ recompile ordered use_nl */ count(*) from t_heap t, t_small s, t_small x, t_tri u where t.g = s.g and s.g = x.g and x.g = u.g and u.w = @pv;
show trace;
select /*+ recompile ordered use_nl parallel(0) */ count(*) from t_heap t, t_small s, t_small x, t_tri u where t.g = s.g and s.g = x.g and x.g = u.g and u.w = @pv;
deallocate variable @pv;


evaluate 'Case 9: a correlated derived table beside the driving heap joins every row; result = parallel(0)';
select /*+ recompile ordered use_nl */ count(*), sum(d.m) from t_heap t, (select max(s.k) m from t_small s where s.g = t.g) d;
select /*+ recompile ordered use_nl parallel(0) */ count(*), sum(d.m) from t_heap t, (select max(s.k) m from t_small s where s.g = t.g) d;
select /*+ recompile ordered use_nl */ t.g, count(*), sum(d.m) from t_heap t, (select max(s.k) m from t_small s where s.g = t.g) d group by t.g order by t.g;
select /*+ recompile ordered use_nl parallel(0) */ t.g, count(*), sum(d.m) from t_heap t, (select max(s.k) m from t_small s where s.g = t.g) d group by t.g order by t.g;


evaluate 'Case 10: correlated subqueries on the inner table and an inner table with no used column; result = parallel(0)';
select /*+ recompile ordered use_nl */ count(*), sum(t.v) from t_heap t, t_small s where t.g = s.g and exists (select 1 from t_tri u where u.g = s.g and u.w = mod(t.v, 3));
select /*+ recompile ordered use_nl parallel(0) */ count(*), sum(t.v) from t_heap t, t_small s where t.g = s.g and exists (select 1 from t_tri u where u.g = s.g and u.w = mod(t.v, 3));
select /*+ recompile */ sum(t.v), max((select count(*) from t_tri u where u.g = t.g and u.w <= mod(t.v, 3))) from t_heap t;
select /*+ recompile parallel(0) */ sum(t.v), max((select count(*) from t_tri u where u.g = t.g and u.w <= mod(t.v, 3))) from t_heap t;
-- trace goes off before the last query: the plan of a traced query that no show trace reads stays in the
-- session, and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile ordered use_nl */ t.id, count(*) from t_heap t, t_small s where t.id <= 2 group by t.id order by 1;
select /*+ recompile ordered use_nl parallel(0) */ t.id, count(*) from t_heap t, t_small s where t.id <= 2 group by t.id order by 1;


drop table t_heap, t_small, t_mid, t_tri;
