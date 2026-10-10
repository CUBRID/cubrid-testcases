/**
 *  This test case verifies CBRD-27588: an uncorrelated scalar subquery in the predicate of a parallel
 *  heap scan gathered row by row runs once per query, not once per worker.
 *
 *  CBRD-26931 runs such a subquery once on the main thread and copies its value into the workers, but
 *  the copy was made only for the buildvalue and list gathers. Under the row-by-row gather (ROWNUM beside
 *  an aggregate or GROUP BY, a ROWNUM lower bound, a select-list function without PARALLEL_ENABLE) every
 *  worker ran the subquery again, so NEXT_VALUE gave each worker its own value to filter with, and the
 *  rows came back wrong. The fix copies the value into the workers under every gather.
 *
 *  Each tested query is followed by a twin with no_parallel_scan in every query block, run on a serial
 *  created again, and the two blocks must match. The serial's current value is read as a row and counts
 *  the runs of the subquery. CTP masks digits, so the trace asserts the gather token only.
 *
 *  Coverage:
 *    Case 1:  aggregate with ROWNUM, the reported query
 *    Case 2:  GROUP BY with ROWNUM
 *    Case 3:  ROWNUM lower bound without an aggregate
 *    Case 4:  PL/CSQL function without PARALLEL_ENABLE in the select list, no ROWNUM
 *    Case 5:  INSERT ... SELECT stores the aggregate
 *    Case 6:  a subquery that cannot change the result still runs once
 *    Case 7:  partitioned table, one row-by-row pass per partition
 */

drop table if exists t_big, t_part, t_res;
drop serial if exists s_seq;

-- 100000 rows, about 8 times the 32 pages test_mode needs for a parallel heap scan, no index so every
-- query scans the heap. c = 1..100000 and the subquery value 1 keeps c > 10000, g splits those rows
-- 45000 / 27000 / 18000
create table t_big (c int, g int, v int);
insert into t_big select rownum, case when mod(rownum, 10) < 5 then 0 when mod(rownum, 10) < 8 then 1 else 2 end, mod(rownum * 37, 1000) from db_class a, db_class b, db_class c, db_class d limit 100000;
-- the same c in two range partitions of 50000 rows, each partition about 18 times the 32 pages
create table t_part (c int, v int, pad varchar(200)) partition by range (c) (partition p_lo values less than (50001), partition p_hi values less than maxvalue);
insert into t_part select c, v, sha2(to_char(c), 512) from t_big;
-- target of Case 5
create table t_res (cnt int, mn int);
update statistics on t_big, t_part, t_res with fullscan;
-- a PL/CSQL function without PARALLEL_ENABLE in the select list sends the scan to the row-by-row gather
create or replace function f_id (x int) return int as begin return x; end;
create serial s_seq;

set trace on;


evaluate 'Case 1: aggregate with ROWNUM, the reported query; result = no_parallel_scan';
select /*+ recompile */ count(*), min(c) from t_big where c > (select s_seq.next_value from db_root) * 10000 and rownum <= 200000;
show trace;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;
select /*+ recompile no_parallel_scan */ count(*), min(c) from t_big where c > (select /*+ no_parallel_scan */ s_seq.next_value from db_root) * 10000 and rownum <= 200000;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;


evaluate 'Case 2: GROUP BY with ROWNUM; result = no_parallel_scan';
select /*+ recompile */ g, count(*), min(c) from t_big where c > (select s_seq.next_value from db_root) * 10000 and rownum <= 200000 group by g order by g;
show trace;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;
select /*+ recompile no_parallel_scan */ g, count(*), min(c) from t_big where c > (select /*+ no_parallel_scan */ s_seq.next_value from db_root) * 10000 and rownum <= 200000 group by g order by g;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;


evaluate 'Case 3: ROWNUM lower bound without an aggregate; result = no_parallel_scan';
select /*+ recompile */ c from t_big where c > (select s_seq.next_value from db_root) * 10000 and mod(c, 10000) = 0 and rownum >= 1 order by c;
show trace;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;
select /*+ recompile no_parallel_scan */ c from t_big where c > (select /*+ no_parallel_scan */ s_seq.next_value from db_root) * 10000 and mod(c, 10000) = 0 and rownum >= 1 order by c;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;


evaluate 'Case 4: PL/CSQL function without PARALLEL_ENABLE in the select list; result = no_parallel_scan';
select /*+ recompile */ f_id (c) from t_big where c > (select s_seq.next_value from db_root) * 10000 and mod(c, 10000) = 0 order by 1;
show trace;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;
select /*+ recompile no_parallel_scan */ f_id (c) from t_big where c > (select /*+ no_parallel_scan */ s_seq.next_value from db_root) * 10000 and mod(c, 10000) = 0 order by 1;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;


evaluate 'Case 5: INSERT SELECT stores the aggregate; result = no_parallel_scan';
insert into t_res select /*+ recompile */ count(*), min(c) from t_big where c > (select s_seq.next_value from db_root) * 10000 and rownum <= 200000;
select cnt, mn from t_res;
select s_seq.current_value;
delete from t_res;
drop serial s_seq;
create serial s_seq;
insert into t_res select /*+ recompile no_parallel_scan */ count(*), min(c) from t_big where c > (select /*+ no_parallel_scan */ s_seq.next_value from db_root) * 10000 and rownum <= 200000;
select cnt, mn from t_res;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;


evaluate 'Case 6: a subquery that cannot change the result still runs once; result = no_parallel_scan';
select /*+ recompile */ count(*) from t_big where v >= (select s_seq.next_value from db_root) * 0 and rownum <= 50000;
show trace;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;
select /*+ recompile no_parallel_scan */ count(*) from t_big where v >= (select /*+ no_parallel_scan */ s_seq.next_value from db_root) * 0 and rownum <= 50000;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;


evaluate 'Case 7: partitioned table, one row-by-row pass per partition; result = no_parallel_scan';
select /*+ recompile */ count(*), min(c) from t_part where c > (select s_seq.next_value from db_root) * 10000 and rownum <= 200000;
show trace;
select s_seq.current_value;
drop serial s_seq;
create serial s_seq;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan */ count(*), min(c) from t_part where c > (select /*+ no_parallel_scan */ s_seq.next_value from db_root) * 10000 and rownum <= 200000;
select s_seq.current_value;

drop serial s_seq;
drop function f_id;
drop table t_big, t_part, t_res;
