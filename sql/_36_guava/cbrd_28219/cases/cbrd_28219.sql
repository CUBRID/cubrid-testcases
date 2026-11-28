/*
 * CBRD-28219: a VALUES operand of a set operation whose string column takes the
 * collation of the set operation.
 *
 * The select list of a VALUES query is its list of rows. The collation of the set
 * operation was applied to the values of the first row only, and their cast took
 * the place of the row list, which crashed the client. Once every row was cast,
 * the values still compared in the system collation, because the cast to the
 * common type of the set operation replaced the collation with the default one.
 *
 * Every row of the VALUES operand must compare in the collation of the column of
 * the other operand (utf8_en_ci here, so 'A' and 'a' are one value). The surviving
 * spelling of equal values is not fixed, so the results are counted or lowered.
 *
 * Coverage:
 *   Case 1: UNION ALL, UNION, DIFFERENCE and INTERSECTION with a one-row VALUES operand, on either side
 *   Case 2: a VALUES operand of several rows, and values of different lengths
 *   Case 3: several columns, and a nested set operation of VALUES queries
 *   Case 4: the collation and the order of the result
 *   Case 5: a set operation folded to its VALUES operand because the other one is empty
 *   Case 6: a view on the set operation
 *   Case 7: operands of the same collation, unchanged
 */
drop view if exists v_28219;
drop table if exists t_28219_ci, t_28219_ci2, t_28219_bin;
create table t_28219_ci (s varchar(10) collate utf8_en_ci);
insert into t_28219_ci values ('a');
create table t_28219_ci2 (i int, s varchar(10) collate utf8_en_ci);
insert into t_28219_ci2 values (1, 'a');
create table t_28219_bin (s varchar(10) collate utf8_bin);
insert into t_28219_bin values ('b'), ('b'), ('c');

evaluate 'Case 1: UNION ALL, UNION, DIFFERENCE and INTERSECTION with a one-row VALUES operand: 2, 1, 2, 1, 0, 1';
select count(*) from (values ('a') union all (select s from t_28219_ci)) u;
select count(*) from (values ('A') union (select s from t_28219_ci)) u;
select count(*) from ((select s from t_28219_ci) union all values ('A')) u;
select count(*) from ((select s from t_28219_ci) union values ('A')) u;
select count(*) from (values ('A') difference (select s from t_28219_ci)) u;
select count(*) from (values ('A') intersection (select s from t_28219_ci)) u;

evaluate 'Case 2: a VALUES operand of several rows, and values of different lengths: 2, 1, 2, 1';
select count(*) from (values ('A'), ('a'), ('b') union (select s from t_28219_ci)) u;
select count(*) from (values ('A'), ('a') union (select s from t_28219_ci)) u;
select count(*) from (values ('A'), ('bb') union (select s from t_28219_ci)) u;
select count(*) from (values ('A'), ('b') intersection (select s from t_28219_ci)) u;

evaluate 'Case 3: several columns, and a nested set operation of VALUES queries: 2, 1, 1, 3';
select count(*) from (values (1, 'A'), (2, 'a') union (select i, s from t_28219_ci2)) u;
select count(*) from (values (1, 'A'), (1, 'bb') intersection (select i, s from t_28219_ci2)) u;
select count(*) from ((values ('A') union all values ('a')) union (select s from t_28219_ci)) u;
select count(*) from (values ('A') union all (select s from t_28219_ci) union all values ('Z')) u;

evaluate 'Case 4: the collation and the order of the result: utf8_en_ci, then a, B, C';
select collation (x) from (values ('A') union all (select s from t_28219_ci)) u (x) limit 1;
select x from (values ('C'), ('B') union all (select s from t_28219_ci)) u (x) order by 1;

evaluate 'Case 5: a set operation folded to its VALUES operand because the other one is empty: 1, 1';
select count(*) from (values ('A'), ('a') union (select s from t_28219_ci where 1 = 0)) u;
select count(*) from ((select s from t_28219_ci where 1 = 0) union values ('A'), ('a')) u;

evaluate 'Case 6: a view on the set operation: a, b';
create view v_28219 (x) as values ('A'), ('b') union (select s from t_28219_ci);
select lower (x) from v_28219 order by 1;

evaluate 'Case 7: operands of the same collation, unchanged: 4, 3';
select count(*) from (values ('a') union all (select s from t_28219_bin)) u;
select count(*) from (values ('a'), ('b') union (select s from t_28219_bin)) u;

drop view v_28219;
drop table t_28219_ci, t_28219_ci2, t_28219_bin;
