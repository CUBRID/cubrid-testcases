/**
 *  This test case verifies CBRD-28019: a set operation that a driver prepared returns no row, instead of an
 *  internal error that closes the connection, when the values bound at execution make every operand empty
 *
 *  A statement whose printed text is ambiguous in type is typed again at each execution with the values of
 *  its host variables and auto-parameterized literals. When those values made the WHERE of every operand
 *  false, the set operation was folded into a value that the executor does not run. CTP runs the statements
 *  through the driver, so the literals of Case 1 to Case 5 take that path.
 *  The same change fixes two defects of folding a set operation to the operand that is left - a UNION or an
 *  EXCEPT without ALL returned the duplicate rows of that operand, and a set operation whose operands both
 *  have a WITH clause asserted in a debug build when one operand was empty. A set operation whose operand
 *  left cannot remove the duplicates in its own block, such as one with LIMIT, is now kept and not folded.
 *  From Case 6 on, each query with an operand whose WHERE is the constant 1 = 0 is followed by a twin whose
 *  empty operand is not constant, so it is never folded, and the two print the same rows.
 *
 *  Coverage:
 *    Case 1:  the issue query - both operands turn empty at execution - returns no row
 *    Case 2:  one operand of the issue query alone returns no row
 *    Case 3:  UNION of an operand that turns empty at execution and an operand with duplicates removes them
 *    Case 4:  the same with UNION ALL keeps the duplicates
 *    Case 5:  the same with EXCEPT removes the duplicates
 *    Case 6:  UNION with an empty left operand removes the duplicates of the right operand
 *    Case 7:  UNION with an empty right operand removes the duplicates of the left operand
 *    Case 8:  EXCEPT with an empty right operand removes the duplicates of the left operand
 *    Case 9:  UNION ALL and EXCEPT ALL with an empty operand keep the duplicates
 *    Case 10: the operand left has ORDER BY with or without LIMIT - the duplicates are removed after its LIMIT
 *    Case 11: the operand left is a UNION ALL or an EXCEPT ALL
 *    Case 12: the operand left has GROUP BY or an analytic function
 *    Case 13: the set operation is a derived table or an IN subquery
 *    Case 14: both the set operation and the operand left have a WITH clause - in a query, in CREATE TABLE ... AS
 *             and in CREATE VIEW, typed by the operands
 *    Case 15: the operand left has an INTO and a LIMIT - the statement folds to it and assigns the row
 *    Case 16: an operand is a set operation whose own operands are all empty - it folds into an empty
 *             operand, not into a value, under UNION, EXCEPT, INTERSECT and WITH
 *    Case 17: an operand whose WHERE is the literal FALSE
 *    Case 18: the operand left has ORDERBY_NUM () or GROUPBY_NUM () in its select list
 *    Case 19: an operand has FOR UPDATE - the statement folds as before
 *    Case 20: INTERSECT with one operand and EXCEPT with the left operand that turn empty at execution
 *             return no row
 *    Case 21: the operand left orders by a column outside its select list, in a derived table and a CTE, and
 *             the set operation itself orders by a column outside its select list - that one folds as before
 *    Case 22: a nested set operation whose operands are all empty by the literal FALSE, in a derived table
 *             and a CTE, which are typed while their names are resolved
 *    Case 23: a view of a set operation with an empty operand, ordered by a column of the select list and by
 *             a column outside it, which folds as before
 *    Case 24: the set operation orders by a column outside its select list and the operand left cannot take
 *             DISTINCT - it folds as before
 *    Case 25: the set operation has LIMIT without ORDER BY and the operand left has GROUP BY
 *    Case 26: an operand empty because its derived table or CTE is empty
 */
drop view if exists v_28019_w;
drop view if exists v_28019_a;
drop view if exists v_28019_b;
drop table if exists t, t_dup, t_ob, t_28019_w;
create table t (c0 varchar, c1 double);
insert into t values ('', 1), ('a', 2), ('3', 3);
create table t_dup (a int);
insert into t_dup values (1), (1), (2), (3), (3);

-- the CASE with one string and two columns makes the printed text ambiguous in type, so the statement is
-- typed again at each execution, and c0 = '' put into c0 != c0 turns the WHERE false only with the values
evaluate 'Case 1: the issue query - both operands turn empty at execution - returns no row';
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''))
union all
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''));

evaluate 'Case 2: one operand of the issue query alone returns no row';
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''));

-- the right operand returns each c1 three times
evaluate 'Case 3: UNION of an operand that turns empty at execution and an operand with duplicates removes them; result = 1, 2, 3';
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''))
union
select t.c1 from t, t t2
order by 1;

evaluate 'Case 4: the same with UNION ALL keeps the duplicates; result = 9 rows';
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''))
union all
select t.c1 from t, t t2
order by 1;

evaluate 'Case 5: the same with EXCEPT removes the duplicates; result = 1, 2, 3';
select t.c1 from t, t t2
except
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''))
order by 1;

-- t_dup holds 1, 1, 2, 3, 3
evaluate 'Case 6: UNION with an empty left operand removes the duplicates of the right operand; result = 1, 2, 3';
select a from t_dup where 1 = 0 union select a from t_dup order by 1;
select a from t_dup where a < -1000 union select a from t_dup order by 1;
select a from t_dup where 1 = 0 union select a from t_dup order by a;

evaluate 'Case 7: UNION with an empty right operand removes the duplicates of the left operand; result = 1, 2, 3';
select a from t_dup union select a from t_dup where 1 = 0 order by 1;
select a from t_dup union select a from t_dup where a < -1000 order by 1;

evaluate 'Case 8: EXCEPT with an empty right operand removes the duplicates of the left operand; result = 1, 2, 3';
select a from t_dup except select a from t_dup where 1 = 0 order by 1;
select a from t_dup except select a from t_dup where a < -1000 order by 1;

evaluate 'Case 9: UNION ALL and EXCEPT ALL with an empty operand keep the duplicates; result = 1, 1, 2, 3, 3';
select a from t_dup where 1 = 0 union all select a from t_dup order by 1;
select a from t_dup where a < -1000 union all select a from t_dup order by 1;
select a from t_dup except all select a from t_dup where 1 = 0 order by 1;
select a from t_dup except all select a from t_dup where a < -1000 order by 1;

evaluate 'Case 10: the operand left has ORDER BY with or without LIMIT - the duplicates are removed after its LIMIT; result = 1, 2 and 1 and 1, 2, 3 and 1, 2 named x';
(select a from t_dup order by a limit 3) union select a from t_dup where 1 = 0 order by 1;
(select a from t_dup order by a limit 3) union select a from t_dup where a < -1000 order by 1;
(select a from t_dup order by a limit 3) union select a from t_dup where 1 = 0 order by 1 limit 1;
(select a from t_dup order by a limit 3) union select a from t_dup where a < -1000 order by 1 limit 1;
(select a from t_dup order by a desc) union select a from t_dup where 1 = 0 order by 1;
(select a from t_dup order by a desc) union select a from t_dup where a < -1000 order by 1;
-- the set operation kept for its DISTINCT is typed as one: its column takes the name of the first operand and the
-- type both operands share, as when its empty operand is not constant
select 0.5 x from t_dup where 1 = 0 union (select a y from t_dup order by a limit 3) order by 1;
select 0.5 x from t_dup where a < -1000 union (select a y from t_dup order by a limit 3) order by 1;

evaluate 'Case 11: the operand left is a UNION ALL or an EXCEPT ALL; result = 1, 2, 3 and 1, 3';
(select a from t_dup union all select a from t_dup where a > 1) union select a from t_dup where 1 = 0 order by 1;
(select a from t_dup union all select a from t_dup where a > 1) union select a from t_dup where a < -1000 order by 1;
(select a from t_dup except all select a from t_dup where a = 2) union select a from t_dup where 1 = 0 order by 1;
(select a from t_dup except all select a from t_dup where a = 2) union select a from t_dup where a < -1000 order by 1;

evaluate 'Case 12: the operand left has GROUP BY or an analytic function; result = 1, 2 and three rows';
select count(*) from t_dup group by a union select 0 from t_dup where 1 = 0 order by 1;
select count(*) from t_dup group by a union select 0 from t_dup where a < -1000 order by 1;
select a, rank() over (order by a) from t_dup union select a, 0 from t_dup where 1 = 0 order by 1, 2;
select a, rank() over (order by a) from t_dup union select a, 0 from t_dup where a < -1000 order by 1, 2;

evaluate 'Case 13: the set operation is a derived table or an IN subquery; result = 1, 2, 3 and 1, 1, 2';
select a from (select a from t_dup where 1 = 0 union select a from t_dup) dt order by 1;
select a from (select a from t_dup where a < -1000 union select a from t_dup) dt order by 1;
select a from t_dup where a in (select a from t_dup where 1 = 0 union (select a from t_dup order by a limit 3)) order by 1;
select a from t_dup where a in (select a from t_dup where a < -1000 union (select a from t_dup order by a limit 3)) order by 1;

-- the operand left reads c of the outer WITH clause in the last pair
evaluate 'Case 14: both the set operation and the operand left have a WITH clause; result = 1, 2, 3 and 1, 1, 2, 3, 3 and 2, 3, then an INTEGER table of 1, 1, 2, 3, 3 and an INTEGER view of 1, 2, 3';
with c as (select 1 x) (select x from c where 1 = 0) union (with d as (select a y from t_dup) select y from d) order by 1;
with c as (select 1 x) (select x from c where x < -1000) union (with d as (select a y from t_dup) select y from d) order by 1;
with c as (select 1 x) (select x from c where 1 = 0) union all (with d as (select a y from t_dup) select y from d) order by 1;
with c as (select 1 x) (select x from c where x < -1000) union all (with d as (select a y from t_dup) select y from d) order by 1;
with c as (select 2 x) (select x from c where 1 = 0) union (with d as (select a y from t_dup) select y from d, c where d.y >= c.x) order by 1;
with c as (select 2 x) (select x from c where x < -1000) union (with d as (select a y from t_dup) select y from d, c where d.y >= c.x) order by 1;
-- the empty operand used to become a NULL value inside the set operation that was kept, which the result
-- columns, a table and a view made from it could not take
create table t_28019_w as with c as (select 1 x) (select x from c where 1 = 0) union all (with d as (select a y from t_dup) select y from d);
show columns from t_28019_w;
select x from t_28019_w order by 1;
create view v_28019_w as with c as (select 1 x) (select x from c where 1 = 0) union (with d as (select a y from t_dup) select y from d);
show columns from v_28019_w;
select x from v_28019_w order by 1;
drop view v_28019_w;
drop table t_28019_w;

-- a set operation does not assign the INTO of its first operand, so the statement folds to that operand
-- as before, though its LIMIT keeps it from removing duplicates in its own block
evaluate 'Case 15: the operand left has an INTO and a LIMIT - the statement folds to it and assigns the row; result = 2';
select a into v_28019 from t_dup where a = 2 limit 1 union (select a from t_dup where 1 = 0);
select v_28019;

-- the nested set operation used to be folded into a value before its parent marked it, and the parent kept
-- for its DISTINCT was left with that value as an operand
evaluate 'Case 16: an operand is a set operation whose own operands are all empty; result = 1, 2 and 1, 2, 3 and 1, 2 and 1, 2, 3 and 1, 2, 3';
(select a from t_dup where 1 = 0 union all select a from t_dup where 1 = 0) union (select a from t_dup order by a limit 3) order by 1;
(select a from t_dup where a < -1000 union all select a from t_dup where a < -1000) union (select a from t_dup order by a limit 3) order by 1;
select a from t_dup union all select a from t_dup union (select a from t_dup where 1 = 0 union all select a from t_dup where 1 = 0) order by 1;
select a from t_dup union all select a from t_dup union (select a from t_dup where a < -1000 union all select a from t_dup where a < -1000) order by 1;
(select a from t_dup where 1 = 0 intersect select a from t_dup) union (select a from t_dup order by a limit 3) order by 1;
(select a from t_dup where a < -1000 intersect select a from t_dup) union (select a from t_dup order by a limit 3) order by 1;
select a from t_dup union all select a from t_dup except (select a from t_dup where 1 = 0 union all select a from t_dup where 1 = 0) order by 1;
select a from t_dup union all select a from t_dup except (select a from t_dup where a < -1000 union all select a from t_dup where a < -1000) order by 1;
with c as (select 1 x) (select x from c where 1 = 0 union all select x from c where 1 = 0) union (with d as (select a y from t_dup) select y from d) order by 1;
with c as (select 1 x) (select x from c where x < -1000 union all select x from c where x < -1000) union (with d as (select a y from t_dup) select y from d) order by 1;

-- the literal FALSE is false before typing, so the operand used to be folded into a value the same way
evaluate 'Case 17: an operand whose WHERE is the literal FALSE; result = 1, 2 each';
(select a from t_dup where false) union (select a from t_dup order by a limit 3) order by 1;
(select a from t_dup order by a limit 3) union (select a from t_dup where false) order by 1;
(select a from t_dup where a < -1000) union (select a from t_dup order by a limit 3) order by 1;

-- ORDERBY_NUM () numbers the rows after its block removes duplicates, so the operand does not take DISTINCT
evaluate 'Case 18: the operand left has ORDERBY_NUM () or GROUPBY_NUM () in its select list; result = 5 rows and 3 rows';
select a, 0 from t_dup where 1 = 0 union (select a, orderby_num () from t_dup order by a) order by 1, 2;
select a, 0 from t_dup where a < -1000 union (select a, orderby_num () from t_dup order by a) order by 1, 2;
select a, 0 from t_dup where 1 = 0 union (select a, groupby_num () from t_dup group by a) order by 1, 2;
select a, 0 from t_dup where a < -1000 union (select a, groupby_num () from t_dup group by a) order by 1, 2;

-- FOR UPDATE refuses DISTINCT, and a set operation refuses FOR UPDATE in its operands, so the statement folds as
-- before, also when the operand with FOR UPDATE is the empty one. The FOR UPDATE of the empty operand goes with it,
-- and the operand left takes DISTINCT when it can
evaluate 'Case 19: an operand has FOR UPDATE - the statement folds as before; result = 1, 1, 2, 3, 3 and 1, 1, 2 and 1, 2, 3';
select a from t_dup where 1 = 0 union (select a from t_dup order by a for update);
(select a from t_dup where 1 = 0 for update) union (select a from t_dup order by a limit 3);
(select a from t_dup where 1 = 0 for update) union select a from t_dup order by 1;

-- like Case 1, the values at execution empty the result of the set operation: INTERSECT with one operand empty
-- and EXCEPT with the left operand empty
evaluate 'Case 20: INTERSECT with one operand and EXCEPT with the left operand that turn empty at execution return no row';
select t.c1 from t
intersect
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''));
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''))
except
select t.c1 from t;

-- the names of a derived table and of a CTE are resolved, and its set operation folded, before the ORDER BY of
-- an operand is matched to its select list, where a key outside it becomes a hidden column
create table t_ob (a int, b int);
insert into t_ob values (1, 30), (1, 20), (2, 10);
evaluate 'Case 21: the operand left orders by a column outside its select list; result = 1, 2 each, then 2, 1, 1';
select * from ((select a from t_ob order by b) union (select a from t_ob where false)) d order by 1;
select * from ((select a from t_ob order by b) union (select a from t_ob where a < -1000)) d order by 1;
with w as ((select a from t_ob order by b) union (select a from t_ob where false)) select * from w order by 1;
-- a set operation that is not folded refuses this key, and folded the statement keeps its rows as before
select a from t_ob union select a from t_ob where 1 = 0 order by b;

-- the names of a derived table and of a CTE are resolved, and their set operations typed, before the semantic
-- check: the typing that skips folding still folds a set operation, and marks its operands first
evaluate 'Case 22: a nested set operation empty by the literal FALSE in a derived table and a CTE; result = 1, 2 and 1, 2 and 1, 2, 3 and 1, 2, 3 and 1, 2';
select a from ((select a from t_dup where false union all select a from t_dup where false) union (select a from t_dup order by a limit 3)) dt order by 1;
select a from ((select a from t_dup where a < -1000 union all select a from t_dup where a < -1000) union (select a from t_dup order by a limit 3)) dt order by 1;
select a from (select a from t_dup union all select a from t_dup union (select a from t_dup where false union all select a from t_dup where false)) dt order by 1;
select a from (select a from t_dup union all select a from t_dup union (select a from t_dup where a < -1000 union all select a from t_dup where a < -1000)) dt order by 1;
with c as ((select a from t_dup where false union all select a from t_dup where false) union (select a from t_dup order by a limit 3)) select a from c order by 1;

-- CREATE VIEW keeps an ORDER BY key outside the select list as it is, without a hidden column, so DISTINCT
-- goes on only when the keys are positions in the select list
evaluate 'Case 23: a view of a set operation with an empty operand; result = 1, 2, then 2, 1, 1 as before';
create view v_28019_a as select a from t_ob where 1 = 0 union select a from t_ob order by a;
select * from v_28019_a order by 1;
create view v_28019_b as select a from t_ob union select a from t_ob where 1 = 0 order by b;
select * from v_28019_b;
drop view v_28019_a;
drop view v_28019_b;

-- a set operation refuses a key outside its select list, so a set operation that would be kept for its
-- DISTINCT folds as before
evaluate 'Case 24: ordered by a column outside the select list with an operand that cannot take DISTINCT; result = 3 rows as before';
select a, rank () over (order by a) r from t_ob union select a, 0 from t_ob where 1 = 0 order by b;

-- the LIMIT of the set operation without ORDER BY would number the groups before DISTINCT, so the set
-- operation is kept
evaluate 'Case 25: LIMIT without ORDER BY over an operand with GROUP BY; result = 1, 2';
select a from (select a from t_ob group by a, b union select a from t_ob where 1 = 0 limit 2) dt order by 1;
select a from (select a from t_ob group by a, b union select a from t_ob where a < -1000 limit 2) dt order by 1;

-- an operand is empty when its derived table or CTE is
evaluate 'Case 26: an operand empty because its derived table or CTE is empty; result = 1, 2 each';
select a from (select a from t_dup where 1 = 0) d union (select a from t_dup order by a limit 3) order by 1;
select a from (select a from t_dup where a < -1000) d union (select a from t_dup order by a limit 3) order by 1;
with c as (select a from t_dup where 1 = 0) select a from c union (select a from t_dup order by a limit 3) order by 1;

drop variable v_28019;
drop table t, t_dup, t_ob;
