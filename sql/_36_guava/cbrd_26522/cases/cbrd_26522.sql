/**
 *  This test case verifies CBRD-26522 : Support NL join during parallel heap scan
 *  (follow-up of CBRD-25447 : Support parallel heap scan)
 *
 *  Parallel heap scan is enabled automatically here: CTP runs SQL tests with
 *  test_mode=yes, which lowers parallel_scan_page_threshold from its default
 *  (2048) to 32. ta below is ~4000 rows (> 32 heap pages), so its heap scan is
 *  executed in parallel and the NL join is evaluated inside each parallel worker.
 *  The (parallel workers: ...) line and the "gather:" mode in "show trace" show
 *  whether the driving heap scan ran in parallel and how results were gathered
 *  (mergeable list / buildvalue / row by row).
 *
 *  Note: table/column names use letters (ta/tb/tc, cola..colf), not digits,
 *  because CTP masks digits in the trace output to '?' -- digit-named objects
 *  (t1, col1, ...) would all collapse to "t?"/"col?" and become indistinguishable.
 *
 *  Correctness: every parallel case (mergeable list and the buildvalue/count
 *  case) runs the parallel query AND the same query with the NO_PARALLEL_SCAN
 *  hint (serial). Both result blocks must be identical -- this proves the
 *  parallel NL join produces no missing/duplicate rows (and the parallel
 *  buildvalue aggregate matches the serial count), and makes answer
 *  regeneration self-checking.
 *
 *  The four "cannot parallelize NL join" conditions from the issue are all covered:
 *    #1 first(driving) table not parallel-heap-scannable -> Case 11
 *    #2 JAVASP (stored procedure)                        -> Case 4
 *    #3 trailing table scan spec is set                  -> Case 5
 *    #4 trailing table contains a JSON_TABLE scan        -> Case 6
 *
 *  Coverage:
 *    Case 1:  simple NL join            -> mergeable list  (+ serial twin)
 *    Case 2:  outer(left) NL join count -> buildvalue (count only)  (+ serial twin)
 *    Case 3:  cross join                -> mergeable list  (+ serial twin)
 *    Case 4:  SP on the 2nd table       -> row by row (cannot parallelize #2)
 *    Case 5:  2nd table scan spec = set -> row by row (cannot parallelize #3)
 *    Case 6:  2nd table JSON_TABLE scan -> row by row (cannot parallelize #4)
 *    Case 7:  natural left join         -> mergeable list  (+ serial twin, CBRD-26596 shape)
 *    Case 8:  3-way NL join             -> mergeable list  (+ serial twin)
 *    Case 9:  GROUP BY over NL join     -> mergeable list  (+ serial twin)
 *    Case 10: explicit PARALLEL(2) hint -> mergeable list  (+ serial twin)
 *    Case 11: first(driving) table = set collection -> not parallel-heap-scannable (cannot parallelize #1)
 */

drop table if exists ta, tb, tc;
create table ta (id int primary key, cola varchar(20), colb varchar(20), colc varchar(20), cold varchar(20), cole varchar(20), colf varchar(20));
create table tb (id int primary key);
create table tc (id int primary key);

insert into ta
select rownum, lpad(rownum,20,'0'), lpad(rownum % 5,20,'0'), lpad(rownum,20,'0'), lpad(rownum,20,'0'), lpad(rownum,20,'0'), lpad(rownum,20,'0')
from db_class a, db_class b, db_class c, db_class d, db_class e limit 4000;
insert into tb select rownum from db_class limit 5;
insert into tc select rownum from db_class limit 3;

set trace on;


evaluate 'Case 1: simple NL join (driving heap scan) -> mergeable list';
select /*+ recompile ordered */ tb.id from ta, tb where ta.id = tb.id order by 1;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ tb.id from ta, tb where ta.id = tb.id order by 1;
show trace;


evaluate 'Case 2: outer(left) NL join, count only -> buildvalue';
select /*+ recompile */ count(tb.id) from ta left join tb on ta.id = tb.id where ta.cola < 6;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ count(tb.id) from ta left join tb on ta.id = tb.id where ta.cola < 6;
show trace;


evaluate 'Case 3: cross join -> mergeable list';
select /*+ recompile ordered */ ta.id, tb.id from ta, tb where cast(ta.cola as int) < 2 order by 1, 2;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ ta.id, tb.id from ta, tb where cast(ta.cola as int) < 2 order by 1, 2;
show trace;


evaluate 'Case 4: SP on the 2nd table (cannot parallelize #2) -> row by row';
create or replace function sp_inc(n integer) return integer deterministic
is
begin
    return n + 1;
end;

select /*+ recompile ordered */ sp_inc(tb.id) from ta join tb on ta.id = tb.id order by 1;
show trace;

drop function sp_inc;


evaluate 'Case 5: 2nd table scan spec is set (cannot parallelize #3) -> row by row';
select /*+ recompile ordered */ ta.id, tset.v from ta, table({1,2,3}) as tset(v) where cast(ta.cola as int) < 2 order by 1, 2;
show trace;


evaluate 'Case 6: 2nd table JSON_TABLE scan (cannot parallelize #4) -> row by row';
select /*+ recompile ordered */ ta.id, jt.col
from ta, json_table('{"a":[1,[2,3]]}', '$.a[*]' columns (col int path '$')) as jt
where cast(ta.cola as int) < 2 and ta.id = jt.col
order by 1, 2;
show trace;


evaluate 'Case 7: natural left join, outer heap scan + inner index scan (CBRD-26596 shape) -> mergeable list';
select /*+ recompile */ ta.id, ta.cola, tb.id from ta natural left join tb where cast(ta.cola as int) <= 10 order by 1, 2, 3;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ ta.id, ta.cola, tb.id from ta natural left join tb where cast(ta.cola as int) <= 10 order by 1, 2, 3;
show trace;


evaluate 'Case 8: 3-way NL join, driving heap scan parallel + two inner index probes -> mergeable list';
-- order by a non-indexed ta column so the driving ta stays a heap scan (parallel)
select /*+ recompile ordered */ ta.colb, tb.id, tc.id from ta, tb, tc where ta.id = tb.id and tb.id = tc.id order by 1, 2;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ ta.colb, tb.id, tc.id from ta, tb, tc where ta.id = tb.id and tb.id = tc.id order by 1, 2;
show trace;


evaluate 'Case 9: GROUP BY over NL join -> mergeable list';
select /*+ recompile ordered */ ta.colb, count(*) from ta, tb where ta.id = tb.id group by ta.colb order by 1;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ ta.colb, count(*) from ta, tb where ta.id = tb.id group by ta.colb order by 1;
show trace;


evaluate 'Case 10: explicit PARALLEL(2) hint on NL join -> mergeable list';
-- order by the inner-table key so the driving ta stays a heap scan (parallel)
select /*+ recompile ordered parallel(2) */ tb.id, ta.colb from ta, tb where ta.id = tb.id order by 1;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ tb.id, ta.colb from ta, tb where ta.id = tb.id order by 1;
show trace;


evaluate 'Case 11: first(driving) table is a set collection, not parallel-heap-scannable (cannot parallelize #1) -> not parallelized';
-- the driving spec is a set (not a class heap scan), so the NL join is not parallelized
-- (no "parallel workers" line under the driving scan)
select /*+ recompile ordered */ x.v, ta.id from table({1,2,3}) as x(v), ta where ta.id = x.v order by 1, 2;
show trace;


drop table if exists ta, tb, tc;
