/**
 *  This test case verifies CBRD-27510 (engine PR #8159): after a parallel scan whose worker lists are
 *  gathered as a mergeable list, the statement returns the serial answer even when the gathered block
 *  calls a PARALLEL_ENABLE Java function that takes an int, and the function runs only for the rows.
 *
 *  Before the fix the leader evaluated the gathered block's select list once more over empty column
 *  values, so the Java function got NULL for its int parameter and failed with -889. The error was
 *  ignored but stayed set: a later stored function call of the same statement then failed with -889,
 *  and on a debug build the next parallel heap scan open asserted and the server stopped. A function
 *  that accepts NULL ran once more than the rows. The fix drops that evaluation.
 *
 *  Every tested query is followed by its twin with no_parallel_scan on every query block, and the two
 *  result blocks must match. The line "gather: mergeable list" under the parallel scan proves the
 *  gathered path, and a FUNC line is printed only when a function ran; CTP masks the digits, so only
 *  the lines are asserted.
 *
 *  Coverage:
 *    Case 1: analytic PARTITION BY over a parallel heap scan, an undeclared function outside
 *    Case 2: the same block, a declared function outside
 *    Case 3: a plain select list over a parallel heap scan
 *    Case 4: a select list over the parallel temp scan of a materialized CTE
 *    Case 5: a select list over a parallel index scan
 *    Case 6: a select list over a parallel heap scan joined to an inner table
 *    Case 7: a UNION ALL arm that calls a function after the gathered arm
 *    Case 8: no row qualifies, so a function that accepts NULL never runs (no FUNC line)
 *    Case 9: a later derived table that calls a function over its own parallel heap scan
 */

drop table if exists t_big, t_mid, t_wide, t_code;

-- 65536 rows of (int, int), a = b: 145 heap pages, 4.5x the 32-page parallel scan threshold under CTP
create table t_big (a int, b int);
insert into t_big select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 65536;
-- 50000 rows for the later derived table of Case 9: 113 heap pages, 3.5x the threshold
create table t_mid (a int, b int);
insert into t_mid select a, case when mod(a, 1000) = 0 then a - 5 else a + 5 end from t_big where a <= 50000;
-- 262144 rows, a = b, indexed on a: 577 heap pages and 274 index leaf pages, 18x and 8.6x the
-- threshold; the CTE of Case 4 lists every row, about as many pages as the heap
create table t_wide (a int, b int);
insert into t_wide select rownum, rownum from db_class x, db_class y, db_class z, db_class w limit 262144;
create index i_wide_a on t_wide (a);
-- five rows: the inner side of the join in Case 6 and the second arm of Case 7
create table t_code (c int);
insert into t_code values (1), (2), (3), (4), (5);
update statistics on t_big, t_mid, t_wide, t_code with fullscan;

create or replace function f_pin_jp(x int) return int parallel_enable as language java name 'SpTest.testInt(int) return int';
create or replace function f_pin_jn(x int) return int as language java name 'SpTest.testInt(int) return int';
create or replace function f_pin_pp(x int) return int parallel_enable as begin return x + 1; end;

set trace on;


evaluate 'Case 1: analytic PARTITION BY over a parallel heap scan, an undeclared function outside; result = no_parallel_scan';
select /*+ recompile */ f_pin_jn(d.s), d.c from (select max(r) s, count(*) c from (select rank() over (partition by f_pin_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d;
show trace;
select /*+ recompile no_parallel_scan */ f_pin_jn(d.s), d.c from (select /*+ no_parallel_scan */ max(r) s, count(*) c from (select /*+ no_parallel_scan */ rank() over (partition by f_pin_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d;


evaluate 'Case 2: the same block, a declared function outside; result = no_parallel_scan';
select /*+ recompile */ f_pin_jp(d.s), d.c from (select max(r) s, count(*) c from (select rank() over (partition by f_pin_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d;
show trace;
select /*+ recompile no_parallel_scan */ f_pin_jp(d.s), d.c from (select /*+ no_parallel_scan */ max(r) s, count(*) c from (select /*+ no_parallel_scan */ rank() over (partition by f_pin_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d;


evaluate 'Case 3: a plain select list over a parallel heap scan; result = no_parallel_scan';
select /*+ recompile */ f_pin_jn(d.m), d.c from (select max(x) m, count(*) c from (select f_pin_jp(b) mod 6 x from t_big where a <= 3000) z) d;
show trace;
select /*+ recompile no_parallel_scan */ f_pin_jn(d.m), d.c from (select /*+ no_parallel_scan */ max(x) m, count(*) c from (select /*+ no_parallel_scan */ f_pin_jp(b) mod 6 x from t_big where a <= 3000) z) d;


evaluate 'Case 4: a select list over the parallel temp scan of a materialized CTE; result = no_parallel_scan';
with w as (select /*+ materialize */ a, b from t_wide) select /*+ recompile */ f_pin_jn(d.m), d.c from (select max(x) m, count(*) c from (select f_pin_jp(b) mod 6 x from w where a <= 3000) z) d;
show trace;
with w as (select /*+ materialize no_parallel_scan */ a, b from t_wide) select /*+ recompile no_parallel_scan */ f_pin_jn(d.m), d.c from (select /*+ no_parallel_scan */ max(x) m, count(*) c from (select /*+ no_parallel_scan */ f_pin_jp(b) mod 6 x from w where a <= 3000) z) d;


evaluate 'Case 5: a select list over a parallel index scan; result = no_parallel_scan';
select /*+ recompile */ f_pin_jn(d.m), d.c from (select max(x) m, count(*) c from (select f_pin_jp(b) mod 6 x from t_wide where a > 0 and b <= 3000 using index i_wide_a) z) d;
show trace;
select /*+ recompile no_parallel_scan */ f_pin_jn(d.m), d.c from (select /*+ no_parallel_scan */ max(x) m, count(*) c from (select /*+ no_parallel_scan */ f_pin_jp(b) mod 6 x from t_wide where a > 0 and b <= 3000 using index i_wide_a) z) d;


evaluate 'Case 6: a select list over a parallel heap scan joined to an inner table; result = no_parallel_scan';
select /*+ recompile */ f_pin_jn(d.m), d.c from (select max(x) m, count(*) c from (select /*+ ordered use_nl */ f_pin_jp(t.b) mod 6 x from t_big t, t_code k where t.a <= 3000 and k.c = mod(t.a, 5) + 1) z) d;
show trace;
select /*+ recompile no_parallel_scan */ f_pin_jn(d.m), d.c from (select /*+ no_parallel_scan */ max(x) m, count(*) c from (select /*+ ordered use_nl no_parallel_scan */ f_pin_jp(t.b) mod 6 x from t_big t, t_code k where t.a <= 3000 and k.c = mod(t.a, 5) + 1) z) d;


evaluate 'Case 7: a UNION ALL arm that calls a function after the gathered arm; result = no_parallel_scan';
select /*+ recompile */ count(*), max(v) from (select f_pin_jp(b) mod 6 v from t_big where a <= 3000 union all select f_pin_jn(c) from t_code) u;
show trace;
select /*+ recompile no_parallel_scan */ count(*), max(v) from (select /*+ no_parallel_scan */ f_pin_jp(b) mod 6 v from t_big where a <= 3000 union all select /*+ no_parallel_scan */ f_pin_jn(c) from t_code) u;


evaluate 'Case 8: no row qualifies, so a function that accepts NULL never runs; result = no_parallel_scan';
-- before the fix the leader called f_pin_pp once with NULL and the block printed a FUNC line
select /*+ recompile */ count(*), max(x) from (select f_pin_pp(b) x from t_big where a < 0) z;
show trace;
select /*+ recompile no_parallel_scan */ count(*), max(x) from (select /*+ no_parallel_scan */ f_pin_pp(b) x from t_big where a < 0) z;


evaluate 'Case 9: a later derived table that calls a function over its own parallel heap scan; result = no_parallel_scan';
-- the pre-fix debug server stopped here: the second derived table opens its parallel scan after the first left -889
select /*+ recompile no_parallel_subquery */ d.s, e.m from (select max(r) s from (select rank() over (partition by f_pin_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d, (select max(f_pin_jn(b)) m from t_mid where a > 49990) e;
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_subquery no_parallel_scan */ d.s, e.m from (select /*+ no_parallel_scan */ max(r) s from (select /*+ no_parallel_scan */ rank() over (partition by f_pin_jp(b) mod 6 order by a) r from t_big where a <= 3000) z) d, (select /*+ no_parallel_scan */ max(f_pin_jn(b)) m from t_mid where a > 49990) e;

drop function f_pin_jp, f_pin_jn, f_pin_pp;
drop table t_big, t_mid, t_wide, t_code;
