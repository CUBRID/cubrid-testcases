/**
 *  This test case verifies CBRD-28019: a set operation that a driver prepared returns no row, instead of an
 *  internal error that closes the connection, when the values bound at execution make every operand empty
 *
 *  A statement whose printed text is ambiguous in type is typed again at each execution with the values of
 *  its host variables and auto-parameterized literals. When those values made the WHERE of every operand
 *  false, the set operation was folded into a value that the executor does not run. CTP runs the statements
 *  through the driver, so the literals of Case 1 to Case 5 take that path.
 *  The same change fixes defects of folding a set operation to the operand that is left - a UNION or an
 *  EXCEPT without ALL returned the duplicate rows of that operand, and a set operation whose operands both
 *  have a WITH clause asserted in a debug build when one operand was empty. Such a set operation now folds
 *  into a SELECT DISTINCT from a derived table of the operand left, which keeps the block of that operand,
 *  with its LIMIT, numbering and grouping, as it is, and compares the rows in the collations of the set
 *  operation. The derived table that an operand with LIMIT took under the ORDER BY or LIMIT of the set
 *  operation keeps the column names of the set operation, and its ORDER BY is matched to them.
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
 *             and in CREATE VIEW
 *    Case 15: the operand left has an INTO and a LIMIT - the statement folds to it and assigns the row
 *    Case 16: an operand is a set operation whose own operands are all empty, under UNION, EXCEPT, INTERSECT
 *             and WITH
 *    Case 17: an operand whose WHERE is the literal FALSE
 *    Case 18: the operand left has ORDERBY_NUM () or GROUPBY_NUM () in its select list
 *    Case 19: an operand has FOR UPDATE - the operand left with it folds as before
 *    Case 20: INTERSECT with one operand and EXCEPT with the left operand that turn empty at execution
 *             return no row
 *    Case 21: the operand left orders by a column outside its select list, in a derived table and a CTE, and
 *             the set operation itself orders by a column outside its select list - that one folds as before
 *    Case 22: a nested set operation whose operands are all empty by the literal FALSE, in a derived table
 *             and a CTE, which are typed while their names are resolved
 *    Case 23: a view of a set operation with an empty operand, ordered by a column of the select list and by
 *             a column outside it, which folds as before
 *    Case 24: the set operation orders by a column outside its select list over an operand with an analytic
 *             function - it folds as before
 *    Case 25: the set operation has LIMIT without ORDER BY and the operand left has GROUP BY
 *    Case 26: an operand empty because its derived table or CTE is empty
 *    Case 27: an empty operand with another collation - the rows are compared in the collation of the set
 *             operation
 *    Case 28: the operand left has LIMIT under the ORDER BY and LIMIT of the set operation - the folded
 *             statement keeps the column names of the set operation, in a derived table, a CTE, a view and
 *             CREATE TABLE ... AS
 *    Case 29: the same ordered by a name, an alias or an expression of the select list, or by a column outside
 *             it, which the set operation reports
 *    Case 30: a set operation folded inside a correlated subquery
 *    Case 31: the values at execution empty every operand of a nested set operation - returns no row
 *    Case 32: CREATE TABLE ... AS WITH ... over a set operation that folds - the table takes the columns and rows
 *             of the query
 *    Case 33: an empty operand whose WHERE is the literal FALSE, or a set operation of such operands, stays a
 *             query until the set operation folds it and tells its collation - the rows are compared in it
 *             and the duplicates removed, as for the twin (CBRD-28242)
 *    Case 34: an operand empty only once a view is merged, in a subquery that an expression reads - the folded
 *             SELECT has the type of its column
 *    Case 35: an operand already folded into a value beside an ORDER BY key outside the select list - the key is
 *             reported as for the twin
 *    Case 36: EXISTS, NOT EXISTS, IN, NOT IN and = ANY over a set operation folded in a correlated subquery - the
 *             predicate takes the operand back, which it counts only the rows of
 */
drop view if exists v_28019_w;
drop view if exists v_28019_a;
drop view if exists v_28019_b;
drop view if exists v_28019_c;
drop view if exists v_28019_e;
drop table if exists t, t_dup, t_ob, t_ci, t_bin, t_28019_w, t_28019_c, t_28019_d, t_28019_e;
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
-- the set operation folds into a SELECT DISTINCT from a derived table of the operand left, whose column takes the
-- name of the first operand, as when its empty operand is not constant
select 0 x from t_dup where 1 = 0 union (select a y from t_dup order by a limit 3) order by 1;
select 0 x from t_dup where a < -1000 union (select a y from t_dup order by a limit 3) order by 1;

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
-- the set operation used to be kept with its empty operand folded into a NULL value, which the result
-- columns, a table and a view made from it could not take
create table t_28019_w as with c as (select 1 x) (select x from c where 1 = 0) union all (with d as (select a y from t_dup) select y from d);
show columns from t_28019_w;
select x from t_28019_w order by 1;
create view v_28019_w as with c as (select 1 x) (select x from c where 1 = 0) union (with d as (select a y from t_dup) select y from d);
show columns from v_28019_w;
select x from v_28019_w order by 1;
drop view v_28019_w;
drop table t_28019_w;

-- a set operation does not assign the INTO of its first operand, nor would a derived table of that operand,
-- so the statement folds to the operand as before
evaluate 'Case 15: the operand left has an INTO and a LIMIT - the statement folds to it and assigns the row; result = 2';
select a into v_28019 from t_dup where a = 2 limit 1 union (select a from t_dup where 1 = 0);
select v_28019;

-- the nested set operation folds into a value, and the set operation above it folds to its other operand
-- with DISTINCT
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

-- the literal FALSE is false before typing, so the operand is folded into a value before the set operation folds
evaluate 'Case 17: an operand whose WHERE is the literal FALSE; result = 1, 2 each';
(select a from t_dup where false) union (select a from t_dup order by a limit 3) order by 1;
(select a from t_dup order by a limit 3) union (select a from t_dup where false) order by 1;
(select a from t_dup where a < -1000) union (select a from t_dup order by a limit 3) order by 1;

-- ORDERBY_NUM () and GROUPBY_NUM () number the rows in the block of the operand, which the derived table keeps,
-- and DISTINCT removes the duplicates above it
evaluate 'Case 18: the operand left has ORDERBY_NUM () or GROUPBY_NUM () in its select list; result = 5 rows and 3 rows';
select a, 0 from t_dup where 1 = 0 union (select a, orderby_num () from t_dup order by a) order by 1, 2;
select a, 0 from t_dup where a < -1000 union (select a, orderby_num () from t_dup order by a) order by 1, 2;
select a, 0 from t_dup where 1 = 0 union (select a, groupby_num () from t_dup group by a) order by 1, 2;
select a, 0 from t_dup where a < -1000 union (select a, groupby_num () from t_dup group by a) order by 1, 2;

-- FOR UPDATE refuses DISTINCT, and a set operation refuses FOR UPDATE in its operands, so the statement folds as
-- before, when the operand left has FOR UPDATE. The FOR UPDATE of the empty operand goes with it, and the operand
-- left takes DISTINCT
evaluate 'Case 19: an operand has FOR UPDATE; result = 1, 1, 2, 3, 3 and 1, 2 and 1, 2, 3';
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
-- check: the typing that skips folding still folds a set operation
evaluate 'Case 22: a nested set operation empty by the literal FALSE in a derived table and a CTE; result = 1, 2 and 1, 2 and 1, 2, 3 and 1, 2, 3 and 1, 2';
select a from ((select a from t_dup where false union all select a from t_dup where false) union (select a from t_dup order by a limit 3)) dt order by 1;
select a from ((select a from t_dup where a < -1000 union all select a from t_dup where a < -1000) union (select a from t_dup order by a limit 3)) dt order by 1;
select a from (select a from t_dup union all select a from t_dup union (select a from t_dup where false union all select a from t_dup where false)) dt order by 1;
select a from (select a from t_dup union all select a from t_dup union (select a from t_dup where a < -1000 union all select a from t_dup where a < -1000)) dt order by 1;
with c as ((select a from t_dup where false union all select a from t_dup where false) union (select a from t_dup order by a limit 3)) select a from c order by 1;

-- the ORDER BY keys of the set operation go to the SELECT from the derived table as positions, which the view
-- stores, and a key outside the select list folds as before
evaluate 'Case 23: a view of a set operation with an empty operand; result = 1, 2, then 2, 1, 1 as before';
create view v_28019_a as select a from t_ob where 1 = 0 union select a from t_ob order by a;
select * from v_28019_a order by 1;
create view v_28019_b as select a from t_ob union select a from t_ob where 1 = 0 order by b;
select * from v_28019_b;
drop view v_28019_a;
drop view v_28019_b;

-- the SELECT from a derived table cannot order by a column outside the select list, so a set operation ordered
-- so folds as before, without DISTINCT
evaluate 'Case 24: ordered by a column outside the select list over an operand with an analytic function; result = 3 rows as before';
select a, rank () over (order by a) r from t_ob union select a, 0 from t_ob where 1 = 0 order by b;

-- the LIMIT of the set operation without ORDER BY goes on the SELECT from the derived table, after DISTINCT,
-- not into the HAVING of the operand with GROUP BY
evaluate 'Case 25: LIMIT without ORDER BY over an operand with GROUP BY; result = 1, 2';
select a from (select a from t_ob group by a, b union select a from t_ob where 1 = 0 limit 2) dt order by 1;
select a from (select a from t_ob group by a, b union select a from t_ob where a < -1000 limit 2) dt order by 1;

-- an operand is empty when its derived table or CTE is
evaluate 'Case 26: an operand empty because its derived table or CTE is empty; result = 1, 2 each';
select a from (select a from t_dup where 1 = 0) d union (select a from t_dup order by a limit 3) order by 1;
select a from (select a from t_dup where a < -1000) d union (select a from t_dup order by a limit 3) order by 1;
with c as (select a from t_dup where 1 = 0) select a from c union (select a from t_dup order by a limit 3) order by 1;

-- the empty operand fixes the collation of the column, so the set operation compares in it and the operand left
-- takes it, as when the empty operand is not constant
create table t_ci (c varchar(10) collate utf8_en_ci);
insert into t_ci values ('a'), ('A'), ('b'), ('a');
create table t_bin (c varchar(10) collate utf8_bin);
insert into t_bin values ('a'), ('A'), ('b'), ('a');
evaluate 'Case 27: an empty operand with another collation; result = A, a, b each, then 2 each';
select c collate utf8_bin from t_ci where 1 = 0 union select c from t_ci order by 1;
select c collate utf8_bin from t_ci where length (c) > 100 union select c from t_ci order by 1;
select c from t_ci union select c collate utf8_bin from t_ci where 1 = 0 order by 1;
select c from t_ci union select c collate utf8_bin from t_ci where length (c) > 100 order by 1;
select c from t_ci union select c collate utf8_bin from t_ci where 1 = 0 order by c;
select c from t_ci union select c collate utf8_bin from t_ci where length (c) > 100 order by c;
select c from t_ci except select c collate utf8_bin from t_ci where 1 = 0 order by c;
select c from t_ci except select c collate utf8_bin from t_ci where length (c) > 100 order by c;
select count (*) from (select c from t_bin union select c collate utf8_en_ci from t_bin where 1 = 0) x;
select count (*) from (select c from t_bin union select c collate utf8_en_ci from t_bin where length (c) > 100) x;

-- the derived table that the operand left with LIMIT takes under the ORDER BY and LIMIT of the set operation keeps
-- the column names of the set operation, also when the names of a derived table or a CTE are resolved
evaluate 'Case 28: the folded statement keeps the column names of the set operation; result = 1, 1 each, then x of INTEGER with 1, 1 twice';
select a from ((select a from t_dup order by a limit 3) union all (select a from t_dup where false) order by 1 limit 2) dt order by 1;
select a from ((select a from t_dup order by a limit 3) union all (select a from t_dup where a < -1000) order by 1 limit 2) dt order by 1;
select * from ((select a x from t_dup order by a limit 3) union all (select a from t_dup where false) order by 1 limit 2) dt order by 1;
select * from ((select a x from t_dup order by a limit 3) union all (select a from t_dup where a < -1000) order by 1 limit 2) dt order by 1;
with w as ((select a from t_dup order by a limit 3) union all (select a from t_dup where false) order by 1 limit 2) select a from w order by 1;
create view v_28019_c as (select a x from t_dup order by a limit 3) union all select a from t_dup where 1 = 0 order by 1 limit 2;
show columns from v_28019_c;
select x from v_28019_c order by 1;
create table t_28019_c as (select a x from t_dup order by a limit 3) union all select a from t_dup where 1 = 0 order by 1 limit 2;
show columns from t_28019_c;
select x from t_28019_c order by 1;
drop view v_28019_c;
drop table t_28019_c;

-- the ORDER BY of the set operation goes to the SELECT from the derived table as positions in its select list,
-- and a key outside the select list is reported by the set operation, as its twin reports it
evaluate 'Case 29: ordered by a name, an alias and an expression of the select list, or by a column outside it; result = 2, 1 three times, then 3, 2, then an error each';
(select a from t_dup order by a limit 3) union all select a from t_dup where 1 = 0 order by a desc limit 2;
(select a from t_dup order by a limit 3) union all select a from t_dup where a < -1000 order by a desc limit 2;
(select a y from t_dup order by a limit 3) union all select a from t_dup where 1 = 0 order by y desc limit 2;
(select a y from t_dup order by a limit 3) union all select a from t_dup where a < -1000 order by y desc limit 2;
(select a from t_dup order by a limit 3) union select a from t_dup where 1 = 0 order by a desc;
(select a from t_dup order by a limit 3) union select a from t_dup where a < -1000 order by a desc;
(select a + 1 from t_dup order by a limit 3) union all select a from t_dup where 1 = 0 order by a + 1 desc limit 2;
(select a + 1 from t_dup order by a limit 3) union all select a from t_dup where a < -1000 order by a + 1 desc limit 2;
(select a from t_ob order by a limit 3) union all select a from t_ob where 1 = 0 order by b limit 2;
(select a from t_ob order by a limit 3) union all select a from t_ob where a < -1000 order by b limit 2;

-- the set operation folded inside a correlated subquery removes the duplicates for each row of the outer query
evaluate 'Case 30: a set operation folded inside a correlated subquery; result = 1, 2, 3 each with itself, then 3 each';
select o.a, (select i.a from t_dup i where i.a = o.a union select a from t_dup where 1 = 0) from (select distinct a from t_dup) o order by 1;
select o.a, (select i.a from t_dup i where i.a = o.a union select a from t_dup where a < -1000) from (select distinct a from t_dup) o order by 1;
select count (*) from t_dup o where o.a + 1 in (select i.a from t_dup i where i.a = o.a + 1 union select a from t_dup where 1 = 0);
select count (*) from t_dup o where o.a + 1 in (select i.a from t_dup i where i.a = o.a + 1 union select a from t_dup where a < -1000);

-- like Case 1, the values at execution empty every operand, here of nested set operations, which fold into an
-- empty operand, not into a value
evaluate 'Case 31: the values at execution empty every operand of a nested set operation - returns no row';
(select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''))
union all
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> '')))
union
(select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> ''))
union all
select t.c1 from t
 where ((case t.c0 when 'x' then t.c0 when t.c0 then t.c0 when t.c0 then t.c0 else null end) >= some (select t.c0 from t where t.c1 = cast(t.c0 as bigint)))
   and (t.c0 != t.c0 and not (t.c0 <> '')));

-- CREATE TABLE ... AS WITH ... checks its query apart, and the check folds the set operation into another node
evaluate 'Case 32: CREATE TABLE ... AS WITH ... over a set operation that folds; result = x of INTEGER with 1 and x of INTEGER with 1, 2, 3';
create table t_28019_d as with c as (select 1 x) select x from c union all select x from c where 1 = 0;
show columns from t_28019_d;
select x from t_28019_d order by 1;
create table t_28019_e as with c as (select a x from t_dup) select x from c where 1 = 0 union select x from c;
show columns from t_28019_e;
select x from t_28019_e order by 1;
drop table t_28019_d, t_28019_e;

-- an empty operand in parentheses at the top of a statement is folded into a value while it is typed, before the set
-- operation, and so is a nested set operation whose operands are all empty; a value tells no collation, so a string
-- column folds to the operand left as before, without DISTINCT, and no row is lost (the twins compare in utf8_bin
-- and remove the duplicate 'a'); an operand that is still a query when the set operation folds, here in a derived
-- table, tells its collation, and the rows are compared in utf8_bin. The rows of a derived table are ordered by
-- their bytes, those of the statement without ORDER BY come in the order of the table
evaluate 'Case 33: an empty operand by the literal FALSE tells its collation; result = A, a, b for each query and its twin';
(select c collate utf8_bin from t_ci where false) union select c from t_ci;
(select c collate utf8_bin from t_ci where length (c) > 100) union select c from t_ci order by 1;
select c from ((select c collate utf8_bin c from t_ci where false) union (select c from t_ci)) x order by hex (c);
select c from ((select c collate utf8_bin c from t_ci where length (c) > 100) union (select c from t_ci)) x order by hex (c);
select c from ((select c collate utf8_bin c from t_ci where 1 = 0 union all select c collate utf8_bin from t_ci where 1 = 0) union (select c from t_ci)) x order by hex (c);
select c from ((select c collate utf8_bin c from t_ci where length (c) > 100 union all select c collate utf8_bin from t_ci where length (c) > 100) union (select c from t_ci)) x order by hex (c);

-- the operand reads a view whose WHERE is false, so it turns empty only when the view is merged into it, after
-- the semantic check: the SELECT the set operation folds into takes the type of its column, which an expression
-- over the subquery reads
create view v_28019_e as select a from t_dup where 1 = 0;
evaluate 'Case 34: an operand empty only once a view is merged, in a subquery that an expression reads; result = 2, 20 and 2, each as its twin';
select (select a from t_dup where a = 1 union select a from v_28019_e) + 1 from db_root;
select (select a from t_dup where a = 1 union select a from t_dup where a < -1000) + 1 from db_root;
select (select a from v_28019_e union select a from t_dup where a = 2) * 10 from db_root;
select (select a from t_dup where a < -1000 union select a from t_dup where a = 2) * 10 from db_root;
select count (*) from t_dup o where o.a + 1 = (select a from t_dup where a = 2 union select a from v_28019_e);
select count (*) from t_dup o where o.a + 1 = (select a from t_dup where a = 2 union select a from t_dup where a < -1000);
drop view v_28019_e;

-- an operand folded into a value leaves nothing to check an ORDER BY key outside the select list against, and a set
-- operation with such an operand could not run: the key is reported as the twin reports it
evaluate 'Case 35: an operand already folded into a value beside an ORDER BY key outside the select list; result = an error each';
(select a from t_ob where false) union (select a from t_ob order by a limit 3) order by b;
(select a from t_ob where a < -1000) union (select a from t_ob order by a limit 3) order by b;
(select a from t_ob order by b limit 3) union (select a from t_ob where false) order by b;

-- EXISTS and the comparisons with a subquery (IN, ANY, SOME, ALL) count only which rows it returns: a set operation
-- folded in a correlated subquery gives them its operand back instead of the SELECT DISTINCT from a derived table of
-- it, which is not merged in a correlated subquery and would run for each outer row
evaluate 'Case 36: EXISTS, NOT EXISTS, IN, NOT IN and = ANY over a set operation folded in a correlated subquery; result = 5, 0, 3, 2 and 3, each as its twin';
select count (*) from t_dup o where exists (select 1 from t_dup i where i.a = o.a union select 1 from t_dup where 1 = 0);
select count (*) from t_dup o where exists (select 1 from t_dup i where i.a = o.a union select 1 from t_dup where a < -1000);
select count (*) from t_dup o where not exists (select 1 from t_dup i where i.a = o.a union select 1 from t_dup where 1 = 0);
select count (*) from t_dup o where not exists (select 1 from t_dup i where i.a = o.a union select 1 from t_dup where a < -1000);
select count (*) from t_dup o where o.a in (select i.a + 1 from t_dup i where i.a = o.a - 1 union select a from t_dup where 1 = 0);
select count (*) from t_dup o where o.a in (select i.a + 1 from t_dup i where i.a = o.a - 1 union select a from t_dup where a < -1000);
select count (*) from t_dup o where o.a not in (select i.a + 1 from t_dup i where i.a = o.a - 1 union select a from t_dup where 1 = 0);
select count (*) from t_dup o where o.a not in (select i.a + 1 from t_dup i where i.a = o.a - 1 union select a from t_dup where a < -1000);
select count (*) from t_dup o where o.a = any (select i.a + 1 from t_dup i where i.a = o.a - 1 union select a from t_dup where 1 = 0);
select count (*) from t_dup o where o.a = any (select i.a + 1 from t_dup i where i.a = o.a - 1 union select a from t_dup where a < -1000);

drop variable v_28019;
drop table t, t_dup, t_ob, t_ci, t_bin;
