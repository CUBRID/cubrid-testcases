/**
 *  This test case verifies CBRD-26931: an uncorrelated scalar subquery used as an expression operand is
 *  evaluated once before the outer scan opens, even when no outer row would reach it.
 *
 *  Before engine PR #7316 such a subquery ran on demand, so an empty outer scan, a short-circuited
 *  AND / OR or an untaken CASE branch never ran it. The PR evaluates it in advance so that parallel
 *  workers can share the value, and states the result change as intended: a subquery that returns
 *  two rows now fails with -459 in these places, and its errors and side effects always happen.
 *
 *  There is no switch back to on-demand evaluation, so the expected results are literal and this file
 *  fails on a pre-fix build by design. Each tested query is followed by a no_parallel_scan twin with the
 *  same result: the evaluation does not depend on parallel scan. Controls mark where it does not apply.
 *
 *  Coverage:
 *    Case 1:  empty outer table, two-row subquery = -459, non-empty outer = -459 on any build
 *    Case 2:  empty outer table, one-row subquery: no row, the subquery scan appears in the trace
 *    Case 3:  AND whose other operand is false for every row
 *    Case 4:  OR whose other operand is true for every row
 *    Case 5:  CASE branch that no row takes
 *    Case 6:  HAVING over no group
 *    Case 7:  LIMIT 0 on the statement = no error, LIMIT 0 in a derived table = -459 on any build
 *    Case 8:  select-list operand = -459, bare select-list subquery = no error
 *    Case 9:  DELETE and UPDATE that match no row, controls UPDATE SET and INSERT VALUES
 *    Case 10: inside a correlated subquery, and a subquery that reads the outermost table
 *    Case 11: a conversion error inside the subquery surfaces
 *    Case 12: a serial in a subquery that no row reaches still advances
 */

drop table if exists t_outer, t_empty, t_multi, t_text;
drop serial if exists s_dead;

-- every row has a > 0, so a < 0 is false and a > 0 is true for all of them
create table t_outer (a int, b int);
insert into t_outer values (1, 10), (2, 20), (3, 30);
-- the outer table that returns no row
create table t_empty (a int, b int);
-- two rows: a scalar subquery over it fails with -459 once it runs
create table t_multi (c int);
insert into t_multi values (1), (2);
-- a string that does not convert to int
create table t_text (s varchar(8));
insert into t_text values ('abc');
create serial s_dead;
update statistics on t_outer, t_empty, t_multi, t_text with fullscan;

set trace on;


evaluate 'Case 1: empty outer table and a two-row subquery; result = no_parallel_scan';
select /*+ recompile */ a, b from t_empty where b = (select c from t_multi);
select /*+ recompile no_parallel_scan */ a, b from t_empty where b = (select /*+ no_parallel_scan */ c from t_multi);
select /*+ recompile */ a, b from t_outer where b = (select c from t_multi);


evaluate 'Case 2: empty outer table and a one-row subquery, the subquery scan is in the trace; result = no_parallel_scan';
select /*+ recompile */ a, b from t_empty where b = (select max(c) from t_multi);
show trace;
-- trace goes off before the last query that no show trace reads: its plan would stay in the
-- session and the next case's first show trace over a cached plan would print it
set trace off;
select /*+ recompile no_parallel_scan */ a, b from t_empty where b = (select /*+ no_parallel_scan */ max(c) from t_multi);


evaluate 'Case 3: AND whose other operand is false for every row; result = no_parallel_scan';
select /*+ recompile */ a, b from t_outer where a < 0 and b = (select c from t_multi);
select /*+ recompile no_parallel_scan */ a, b from t_outer where a < 0 and b = (select /*+ no_parallel_scan */ c from t_multi);


evaluate 'Case 4: OR whose other operand is true for every row; result = no_parallel_scan';
select /*+ recompile */ count(*) from t_outer where a > 0 or b = (select c from t_multi);
select /*+ recompile no_parallel_scan */ count(*) from t_outer where a > 0 or b = (select /*+ no_parallel_scan */ c from t_multi);


evaluate 'Case 5: CASE branch that no row takes; result = no_parallel_scan';
select /*+ recompile */ a, case when a > 0 then 0 else (select c from t_multi) end from t_outer order by a;
select /*+ recompile no_parallel_scan */ a, case when a > 0 then 0 else (select /*+ no_parallel_scan */ c from t_multi) end from t_outer order by a;


evaluate 'Case 6: HAVING over no group; result = no_parallel_scan';
select /*+ recompile */ a, count(*) from t_empty group by a having count(*) = (select c from t_multi);
select /*+ recompile no_parallel_scan */ a, count(*) from t_empty group by a having count(*) = (select /*+ no_parallel_scan */ c from t_multi);


evaluate 'Case 7: LIMIT 0 on the statement and in a derived table; result = no_parallel_scan';
select /*+ recompile */ a, b from t_outer where b = (select c from t_multi) limit 0;
select /*+ recompile no_parallel_scan */ a, b from t_outer where b = (select /*+ no_parallel_scan */ c from t_multi) limit 0;
select /*+ recompile */ a, b from (select a, b from t_outer where b = (select c from t_multi) limit 0) dt;
select /*+ recompile no_parallel_scan */ a, b from (select /*+ no_parallel_scan */ a, b from t_outer where b = (select /*+ no_parallel_scan */ c from t_multi) limit 0) dt;


evaluate 'Case 8: select-list operand and bare select-list subquery over an empty table; result = no_parallel_scan';
select /*+ recompile */ a, (select c from t_multi) + 0 from t_empty;
select /*+ recompile no_parallel_scan */ a, (select /*+ no_parallel_scan */ c from t_multi) + 0 from t_empty;
select /*+ recompile */ a, (select c from t_multi) from t_empty;
select /*+ recompile no_parallel_scan */ a, (select /*+ no_parallel_scan */ c from t_multi) from t_empty;


evaluate 'Case 9: DELETE and UPDATE that match no row, UPDATE SET and INSERT VALUES; result = no_parallel_scan';
delete from t_empty where b = (select c from t_multi);
delete from t_empty where b = (select /*+ no_parallel_scan */ c from t_multi);
update t_outer set b = b where a < 0 and b = (select c from t_multi);
update t_outer set b = b where a < 0 and b = (select /*+ no_parallel_scan */ c from t_multi);
update t_outer set b = (select c from t_multi) where a < 0;
update t_outer set b = (select /*+ no_parallel_scan */ c from t_multi) where a < 0;
insert into t_empty values (1, (select c from t_multi));
insert into t_empty values (1, (select /*+ no_parallel_scan */ c from t_multi));
select a, b from t_outer order by a;
select count(*) from t_empty;


evaluate 'Case 10: inside a correlated subquery, and a subquery that reads the outermost table; result = no_parallel_scan';
select /*+ recompile */ o.a, (select count(*) from t_empty e where e.a = o.a and e.b = (select c from t_multi)) from t_outer o order by o.a;
select /*+ recompile no_parallel_scan */ o.a, (select /*+ no_parallel_scan */ count(*) from t_empty e where e.a = o.a and e.b = (select /*+ no_parallel_scan */ c from t_multi)) from t_outer o order by o.a;
select /*+ recompile */ o.a, (select count(*) from t_empty e where e.b = (select o.a from t_multi)) from t_outer o order by o.a;
select /*+ recompile no_parallel_scan */ o.a, (select /*+ no_parallel_scan */ count(*) from t_empty e where e.b = (select /*+ no_parallel_scan */ o.a from t_multi)) from t_outer o order by o.a;


evaluate 'Case 11: a conversion error inside the subquery; result = no_parallel_scan';
select /*+ recompile */ a, b from t_empty where b = (select cast(s as int) from t_text);
select /*+ recompile no_parallel_scan */ a, b from t_empty where b = (select /*+ no_parallel_scan */ cast(s as int) from t_text);


evaluate 'Case 12: a serial in a subquery that no row reaches; result = no_parallel_scan';
select s_dead.next_value;
select /*+ recompile */ a, b from t_empty where b = (select s_dead.next_value from db_root);
select s_dead.current_value;
select /*+ recompile no_parallel_scan */ a, b from t_empty where b = (select /*+ no_parallel_scan */ s_dead.next_value from db_root);
select s_dead.current_value;

drop serial s_dead;
drop table t_outer, t_empty, t_multi, t_text;
