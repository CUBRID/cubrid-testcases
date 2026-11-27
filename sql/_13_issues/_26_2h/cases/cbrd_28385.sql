/**
 *  This test case verifies CBRD-28385: a set operation at the top of a statement whose operands are all empty from
 *  constant conditions returns a result with no row, with the columns of the set operation, instead of not being a
 *  query (Execute OK)
 *
 *  Such a set operation was folded into a NULL value: the statement was no longer a query. Each statement below is
 *  followed by its twin, whose operands are empty only at execution (a < -1000), which the folding does not see:
 *  the two give the same column titles and rows.
 *
 *    Case 1: UNION ALL and UNION whose operands are all empty
 *    Case 2: INTERSECT with one empty operand, EXCEPT with an empty left operand
 *    Case 3: operands empty from a constant-false HAVING
 *    Case 4: ORDER BY and LIMIT on the set operation, a nested set operation
 *    Case 5: operands that read a constant-false CTE, in parentheses or not, and a SELECT in parentheses over it
 *    Case 6: the same set operations in a subquery and a derived table give the answers they gave before
 */
drop table if exists t28385;
create table t28385 (a int, s varchar(10));
insert into t28385 values (1, 'x'), (2, 'y'), (2, 'y');

evaluate 'Case 1: UNION ALL and UNION whose operands are all empty; result = no row, column a, each as its twin';
select a from t28385 where 1 = 2 union all select a from t28385 where 1 = 2;
select a from t28385 where a < -1000 union all select a from t28385 where a < -1000;
select a, s from t28385 where false union select a, s from t28385 where false;
select a, s from t28385 where a < -1000 union select a, s from t28385 where a < -1000;

evaluate 'Case 2: INTERSECT with one empty operand, EXCEPT with an empty left operand; result = no row, each as its twin';
select a from t28385 intersect select a from t28385 where 1 = 2;
select a from t28385 intersect select a from t28385 where a < -1000;
select a from t28385 where 1 = 2 intersect select a from t28385;
select a from t28385 where a < -1000 intersect select a from t28385;
select a from t28385 where 1 = 2 except select a from t28385;
select a from t28385 where a < -1000 except select a from t28385;

evaluate 'Case 3: operands empty from a constant-false HAVING; result = no row, columns a and count(*), as its twin';
select a, count (*) from t28385 group by a having 1 = 2 union all select a, count (*) from t28385 group by a having 1 = 2;
select a, count (*) from t28385 group by a having a < -1000 union all select a, count (*) from t28385 group by a having a < -1000;

evaluate 'Case 4: ORDER BY and LIMIT on the set operation, a nested set operation; result = no row, each as its twin';
select a from t28385 where 1 = 2 union all select a from t28385 where 1 = 2 order by 1 limit 1;
select a from t28385 where a < -1000 union all select a from t28385 where a < -1000 order by 1 limit 1;
(select a from t28385 where 1 = 2 union all select a from t28385 where 1 = 2) union all select a from t28385 where 1 = 2;
(select a from t28385 where a < -1000 union all select a from t28385 where a < -1000) union all select a from t28385 where a < -1000;

evaluate 'Case 5: operands that read a constant-false CTE; result = no row, column x, each as its twin';
with c as (select a x from t28385 where 1 = 0) (select x from c) union all (select x from c);
with c as (select a x from t28385 where a < -1000) (select x from c) union all (select x from c);
with c as (select a x from t28385 where 1 = 0) select x from c union all select x from c;
with c as (select a x from t28385 where a < -1000) select x from c union all select x from c;
with c as (select a x from t28385 where 1 = 0) (select x from c);
with c as (select a x from t28385 where a < -1000) (select x from c);

evaluate 'Case 6: the same set operations in a subquery and a derived table; result = 0, 3, 0 and 1 as before';
select count (*) from (select a from t28385 where 1 = 2 union all select a from t28385 where 1 = 2) x;
select count (*) from t28385 where a not in (select a from t28385 where 1 = 2 union all select a from t28385 where 1 = 2);
select count (*) from t28385 where exists (select a from t28385 where 1 = 2 union select a from t28385 where 1 = 2);
select count (*) from db_root where not exists (select a from t28385 where 1 = 2 except select a from t28385);

drop table t28385;
