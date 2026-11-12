/**
 *  This test case verifies CBRD-27716: a correlated subquery that is a set
 *  operation with a constant-false arm must be evaluated for each outer row.
 *
 *  Folding away the false arm left the remaining arm one correlation level too
 *  high, so the subquery ran once and its XASL cache entry was shared with the
 *  same query without the false arm. The fix lowers the levels of that arm.
 *
 *  Coverage:
 *    Case 1:      XASL cache - the false-arm query compiles first
 *    Case 2-3:    scalar subquery in WHERE and in the SELECT list
 *    Case 4-6:    false arm on the left, UNION distinct, DIFFERENCE
 *    Case 7-8:    folded set operation inside another UNION, remaining operand is a UNION
 *    Case 9-13:   nested subquery, two levels, EXISTS, IN, derived table
 *    Case 14-16:  WITH clause, ORDER BY and LIMIT, LIMIT rewritten as a derived table
 *    Case 17-18:  UPDATE and DELETE
 *    Case 19-22:  correlated set operation or view inside the remaining arm
 *    Case 23-25:  controls - uncorrelated, both arms false, a false condition that is not folded
 */
drop view if exists v_27716;
drop table if exists t_27716, one_27716, u_27716, c_27716;
create table t_27716 (v int);
insert into t_27716 values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
create table one_27716 (x int);
insert into one_27716 values (1);
create table u_27716 (v int, w int);
insert into u_27716 select v, 0 from t_27716;
create table c_27716 (v int);
insert into c_27716 select v from t_27716;

-- Case 1 runs first and without recompile: the false-arm query must fill the XASL cache entry that the plain query reuses
evaluate 'Case 1: XASL cache - the false-arm query compiles first, the plain query reuses its entry, result = 10, 10';
select count(*) from c_27716 t where (select t.v from db_root union all select 2 from db_root where 1 = 0) = t.v;
select count(*) from c_27716 t where (select t.v from db_root) = t.v;

evaluate 'Case 2: scalar subquery in WHERE, result = 10';
select /*+ recompile */ count(*) from t_27716 t where (select t.v from db_root union all select 2 from db_root where 1 = 0) = t.v;
evaluate 'Case 3: scalar subquery in the SELECT list, result = s equals v';
select /*+ recompile */ v, (select t.v from db_root union all select 2 from db_root where 1 = 0) s from t_27716 t order by v;

evaluate 'Case 4: false arm on the left, result = 10';
select /*+ recompile */ count(*) from t_27716 t where (select 2 from db_root where 1 = 0 union all select t.v from db_root) = t.v;
evaluate 'Case 5: UNION distinct, result = 10';
select /*+ recompile */ count(*) from t_27716 t where (select t.v from one_27716 union select 2 from one_27716 where 1 = 0) = t.v;
evaluate 'Case 6: DIFFERENCE, result = 10';
select /*+ recompile */ count(*) from t_27716 t where (select t.v from one_27716 difference select 2 from one_27716 where 1 = 0) = t.v;

-- Case 7 folds the inner parentheses, so the remaining operand there is a SELECT, and the outer UNION is kept
evaluate 'Case 7: a folded set operation nested as an operand of another UNION, result = 10';
select /*+ recompile */ count(*) from t_27716 t
 where (select t.v from one_27716 where t.v >= 0 union (select t.v from one_27716 union all select 2 from one_27716 where 1 = 0)) = t.v;
-- Case 8 folds the outer UNION ALL, so the remaining operand is the UNION of its two left arms
evaluate 'Case 8: the remaining operand is itself a UNION, result = 10';
select /*+ recompile */ count(*) from t_27716 t
 where (select t.v from one_27716 union select t.v from one_27716 union all select 2 from one_27716 where 1 = 0) = t.v;

evaluate 'Case 9: correlated subquery nested in the remaining arm, result = s equals v';
select /*+ recompile */ v, (select (select t.v from db_root) from one_27716 union all select 2 from one_27716 where 1 = 0) s from t_27716 t order by v;

evaluate 'Case 10: two levels of correlation, result = 10';
select /*+ recompile */ count(*) from t_27716 t
 where exists (select 1 from one_27716 o where (select t.v + o.x from db_root union all select 2 from db_root where 1 = 0) = t.v + 1);

evaluate 'Case 11: EXISTS, result = 5';
select /*+ recompile */ count(*) from t_27716 t where exists (select 1 from one_27716 where t.v < 5 union all select 1 from one_27716 where 1 = 0);
evaluate 'Case 12: IN, result = 10';
select /*+ recompile */ count(*) from t_27716 t where t.v in (select t.v from one_27716 union all select 2 from one_27716 where 1 = 0);

evaluate 'Case 13: false arm folded inside a derived table, result = s equals 2v';
select /*+ recompile */ v, (select z from (select t.v * 2 z from one_27716 union all select 7 from one_27716 where 1 = 0) d) s from t_27716 t order by v;

evaluate 'Case 14: WITH clause of the folded set operation moves to the remaining arm, result = 10';
select /*+ recompile */ count(*) from t_27716 t
 where (with w as (select 1 a) select t.v from w union all select 2 from w where 1 = 0) = t.v;

evaluate 'Case 15: ORDER BY and LIMIT of the folded set operation, result = s equals v';
select /*+ recompile */ v, (select t.v from one_27716 union all select 2 from one_27716 where 1 = 0 order by 1 limit 1) s from t_27716 t order by v;
-- unlike Case 15, the remaining arm has its own LIMIT too, so the fold wraps it in a derived table to keep both
evaluate 'Case 16: LIMIT on both the remaining arm and the set operation, rewritten as a derived table, result = 10';
select /*+ recompile */ count(*) from t_27716 t
 where ((select t.v from one_27716 limit 1) union all (select 2 from one_27716 where 1 = 0) order by 1 limit 1) = t.v;

evaluate 'Case 17: UPDATE, result = 10 rows with w equal to v';
update u_27716 u set w = (select u.v from one_27716 union all select 2 from one_27716 where 1 = 0);
select count(*) from u_27716 where w = v;
evaluate 'Case 18: DELETE, result = all 10 rows deleted';
delete from u_27716 u where (select u.v from one_27716 union all select 2 from one_27716 where 1 = 0) = u.v;
select count(*) from u_27716;

evaluate 'Case 19: a correlated set operation nested inside the remaining arm, in the SELECT list, result = s equals v';
select /*+ recompile */ v, (select (select t.v from db_root union select t.v from db_root) from db_root union all select 0 from db_root where 1 = 0) s from t_27716 t order by v;
evaluate 'Case 20: a correlated set operation nested inside the remaining arm, in WHERE, result = 10';
select /*+ recompile */ count(*) from t_27716 t
 where (select (select t.v from db_root union select t.v from db_root) from db_root union all select 0 from db_root where 1 = 0) = t.v;
evaluate 'Case 21: a correlated set operation nested inside the remaining arm, in EXISTS, result = 5';
select /*+ recompile */ count(*) from t_27716 t
 where exists (select 1 from db_root where exists (select 1 from db_root where t.v < 5 union select 1 from db_root where t.v < 5) union all select 1 from db_root where 1 = 0);

evaluate 'Case 22: a view with a constant-false query spec inside the remaining arm, result = s equals v';
create view v_27716 as select v from c_27716 union all select v from c_27716 where 1 = 0;
select /*+ recompile */ v, (select (select w.v from v_27716 w where w.v = t.v) from db_root union all select 0 from db_root where 1 = 0) s from t_27716 t order by v;
drop view v_27716;

evaluate 'Case 23: control - uncorrelated subquery, result = 10';
select /*+ recompile */ count(*) from t_27716 t where (select 1 from db_root union all select 2 from db_root where 1 = 0) = 1;
evaluate 'Case 24: control - both arms false, result = 0';
select /*+ recompile */ count(*) from t_27716 t where (select t.v from one_27716 where 1 = 0 union all select 2 from one_27716 where 1 = 0) is not null;
evaluate 'Case 25: control - a false condition that is not folded, result = 10';
select /*+ recompile */ count(*) from t_27716 t where (select t.v from db_root union all select 2 from db_root where t.v < 0) = t.v;

drop table t_27716, one_27716, u_27716, c_27716;
