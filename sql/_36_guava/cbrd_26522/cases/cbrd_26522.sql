/**
 *  This test case verifies CBRD-26522 : Support NL join during parallel heap scan
 *  (follow-up of CBRD-25447 : Support parallel heap scan)
 *
 *  Parallel heap scan is enabled automatically here: CTP runs SQL tests with
 *  test_mode=yes, which lowers parallel_scan_page_threshold from its default
 *  (2048) to 32. t1 below is ~4000 rows (> 32 heap pages), so its heap scan is
 *  executed in parallel and the NL join is evaluated inside each parallel worker.
 *  The (parallel workers: ...) line and the "gather:" mode in "show trace" show
 *  whether the driving heap scan ran in parallel and how results were gathered
 *  (mergeable list / buildvalue / row by row).
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

drop table if exists t1, t2, t3;
create table t1 (id int primary key, col1 varchar(20), col2 varchar(20), col3 varchar(20), col4 varchar(20), col5 varchar(20), col6 varchar(20));
create table t2 (id int primary key);
create table t3 (id int primary key);

insert into t1
select rownum, lpad(rownum,20,'0'), lpad(rownum % 5,20,'0'), lpad(rownum,20,'0'), lpad(rownum,20,'0'), lpad(rownum,20,'0'), lpad(rownum,20,'0')
from db_class a, db_class b, db_class c, db_class d, db_class e limit 4000;
insert into t2 select rownum from db_class limit 5;
insert into t3 select rownum from db_class limit 3;

set trace on;


evaluate 'Case 1: simple NL join (driving heap scan) -> mergeable list';
select /*+ recompile ordered */ t2.id from t1, t2 where t1.id = t2.id order by 1;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ t2.id from t1, t2 where t1.id = t2.id order by 1;
show trace;


evaluate 'Case 2: outer(left) NL join, count only -> buildvalue';
select /*+ recompile */ count(t2.id) from t1 left join t2 on t1.id = t2.id where t1.col1 < 6;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ count(t2.id) from t1 left join t2 on t1.id = t2.id where t1.col1 < 6;
show trace;


evaluate 'Case 3: cross join -> mergeable list';
select /*+ recompile ordered */ t1.id, t2.id from t1, t2 where cast(t1.col1 as int) < 2 order by 1, 2;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ t1.id, t2.id from t1, t2 where cast(t1.col1 as int) < 2 order by 1, 2;
show trace;


evaluate 'Case 4: SP on the 2nd table (cannot parallelize #2) -> row by row';
create or replace function sp1(n integer) return integer deterministic
is
begin
    return n + 1;
end;

select /*+ recompile ordered */ sp1(t2.id) from t1 join t2 on t1.id = t2.id order by 1;
show trace;

drop function sp1;


evaluate 'Case 5: 2nd table scan spec is set (cannot parallelize #3) -> row by row';
select /*+ recompile ordered */ t1.id, tset.v from t1, table({1,2,3}) as tset(v) where cast(t1.col1 as int) < 2 order by 1, 2;
show trace;


evaluate 'Case 6: 2nd table JSON_TABLE scan (cannot parallelize #4) -> row by row';
select /*+ recompile ordered */ t1.id, jt.col
from t1, json_table('{"a":[1,[2,3]]}', '$.a[*]' columns (col int path '$')) as jt
where cast(t1.col1 as int) < 2 and t1.id = jt.col
order by 1, 2;
show trace;


evaluate 'Case 7: natural left join, outer heap scan + inner index scan (CBRD-26596 shape) -> mergeable list';
select /*+ recompile */ t1.id, t1.col1, t2.id from t1 natural left join t2 where cast(t1.col1 as int) <= 10 order by 1, 2, 3;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile no_parallel_scan */ t1.id, t1.col1, t2.id from t1 natural left join t2 where cast(t1.col1 as int) <= 10 order by 1, 2, 3;
show trace;


evaluate 'Case 8: 3-way NL join, driving heap scan parallel + two inner index probes -> mergeable list';
-- order by a non-indexed t1 column so the driving t1 stays a heap scan (parallel)
select /*+ recompile ordered */ t1.col2, t2.id, t3.id from t1, t2, t3 where t1.id = t2.id and t2.id = t3.id order by 1, 2;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ t1.col2, t2.id, t3.id from t1, t2, t3 where t1.id = t2.id and t2.id = t3.id order by 1, 2;
show trace;


evaluate 'Case 9: GROUP BY over NL join -> mergeable list';
select /*+ recompile ordered */ t1.col2, count(*) from t1, t2 where t1.id = t2.id group by t1.col2 order by 1;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ t1.col2, count(*) from t1, t2 where t1.id = t2.id group by t1.col2 order by 1;
show trace;


evaluate 'Case 10: explicit PARALLEL(2) hint on NL join -> mergeable list';
-- order by the inner-table key so the driving t1 stays a heap scan (parallel)
select /*+ recompile ordered parallel(2) */ t2.id, t1.col2 from t1, t2 where t1.id = t2.id order by 1;
show trace;
-- serial reference: result must match the parallel block above
select /*+ recompile ordered no_parallel_scan */ t2.id, t1.col2 from t1, t2 where t1.id = t2.id order by 1;
show trace;


evaluate 'Case 11: first(driving) table is a set collection, not parallel-heap-scannable (cannot parallelize #1) -> not parallelized';
-- the driving spec is a set (not a class heap scan), so the NL join is not parallelized
-- (no "parallel workers" line under the driving scan)
select /*+ recompile ordered */ x.v, t1.id from table({1,2,3}) as x(v), t1 where t1.id = x.v order by 1, 2;
show trace;


drop table if exists t1, t2, t3;
