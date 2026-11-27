/**
 *  This test case verifies CBRD-27930: Subtotal and grand total rows of WITH ROLLUP return wrong
 *  COUNT(DISTINCT), MEDIAN and ordered GROUP_CONCAT values
 *
 *  An aggregate with DISTINCT or with an ORDER BY collects the values of a group in a list file.
 *  The subtotal and grand total levels of ROLLUP shared that list file with the group level, so
 *  each value went in once per level, and starting the next group emptied what the subtotals and
 *  the grand total had collected. Each level now collects in a list file of its own. Each case
 *  checks one aggregate, over data with a NULL value and a value repeated in two groups.
 *
 *  Coverage:
 *    Case 1:  COUNT(DISTINCT) - each subtotal and the grand total count the values of all their groups
 *    Case 2:  MEDIAN - each subtotal and the grand total take the median of all their values
 *    Case 3:  PERCENTILE_CONT - the same with a fraction other than 0.5
 *    Case 4:  GROUP_CONCAT with ORDER BY - each group row holds its values once, and each subtotal
 *             and the grand total hold the values of all their groups
 *    Case 5:  one GROUP BY column - the grand total holds the values of every group
 *    Case 6:  SUM, which keeps no list file - the same values as before the fix
 *    Case 7:  the query of Case 4 over the index, which skips the sort of the GROUP BY (the issue
 *             comment) - the plan skips the GROUP BY and the rows are those of Case 4
 *    Case 8:  BIT_AND with DISTINCT (an issue comment) - each subtotal and the grand total combine the
 *             distinct values of all their groups
 *    Case 9:  BIT_OR with DISTINCT - the same as Case 8
 *    Case 10: BIT_XOR with DISTINCT - the same as Case 8
 */

drop table if exists t_roll;
create table t_roll (ka int, kb int, v int);
insert into t_roll values (1, 1, 10), (1, 2, 20), (1, 2, null), (2, 1, 30), (2, 2, 30), (2, 2, 40);
create index i_roll on t_roll (ka, kb, v);


evaluate 'Case 1: COUNT(DISTINCT), each subtotal and the grand total count the values of all their groups';
select ka, kb, count(distinct v) as cnt_d from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 2: MEDIAN, each subtotal and the grand total take the median of all their values';
select ka, kb, median(v) as med from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 3: PERCENTILE_CONT with a fraction other than 0.5, the same as MEDIAN';
select ka, kb, percentile_cont(0.25) within group (order by v) as pct from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 4: GROUP_CONCAT with ORDER BY, each group row holds its values once and each subtotal and the grand total hold the values of all their groups';
select ka, kb, group_concat(v order by v) as gc from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 5: one GROUP BY column, the grand total holds the values of every group';
select ka, group_concat(v order by v) as gc from t_roll ignore index (i_roll) where ka > 0 group by ka with rollup order by ka;


evaluate 'Case 6: SUM keeps no list file, the same values as before the fix';
select ka, kb, sum(v) as sm from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 7: the query of Case 4 over the index skips the sort of the GROUP BY; result = the rows of Case 4';
--@queryplan
select ka, kb, group_concat(v order by v) as gc from t_roll force index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 8: BIT_AND with DISTINCT, each subtotal and the grand total combine the distinct values of all their groups';
select ka, kb, bit_and(distinct v) as ba from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 9: BIT_OR with DISTINCT, the same as Case 8';
select ka, kb, bit_or(distinct v) as bo from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 10: BIT_XOR with DISTINCT, the same as Case 8';
select ka, kb, bit_xor(distinct v) as bx from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;

drop table t_roll;
