/**
 *  This test case verifies CBRD-27930: Subtotal and grand total rows of WITH ROLLUP return wrong
 *  COUNT(DISTINCT), MEDIAN and ordered GROUP_CONCAT values
 *
 *  An aggregate with DISTINCT or with an ORDER BY collects the values of a group in a list file.
 *  The subtotal and grand total levels of ROLLUP shared that list file with the group level, so
 *  each value went in once per level, and starting the next group emptied what the subtotals and
 *  the grand total had collected. Each level now collects in a list file of its own. The cases
 *  print the group, subtotal and grand total rows of such aggregates next to COUNT and SUM, which
 *  keep no list file, over data with a NULL value and a value repeated in two groups.
 *
 *  Coverage:
 *    Case 1:  two GROUP BY columns over a heap scan - each group row holds its values once, and
 *             each subtotal and the grand total hold the values of all their groups
 *    Case 2:  one GROUP BY column - the grand total holds the values of every group
 *    Case 3:  the query of Case 1 over the index, which skips the sort of the GROUP BY (the issue
 *             comment) - the plan skips the GROUP BY and the rows are those of Case 1
 */

drop table if exists t_roll;
create table t_roll (ka int, kb int, v int);
insert into t_roll values (1, 1, 10), (1, 2, 20), (1, 2, null), (2, 1, 30), (2, 2, 30), (2, 2, 40);
create index i_roll on t_roll (ka, kb, v);


evaluate 'Case 1: two GROUP BY columns over a heap scan, the subtotals and the grand total hold the values of all their groups';
select ka, kb, count(distinct v) as cnt_d, median(v) as med, percentile_cont(0.25) within group (order by v) as pct, group_concat(v order by v) as gc, count(v) as cnt, sum(v) as sm from t_roll ignore index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;


evaluate 'Case 2: one GROUP BY column, the grand total holds the values of every group';
select ka, count(distinct v) as cnt_d, median(v) as med, percentile_cont(0.25) within group (order by v) as pct, group_concat(v order by v) as gc, count(v) as cnt, sum(v) as sm from t_roll ignore index (i_roll) where ka > 0 group by ka with rollup order by ka;


evaluate 'Case 3: the query of Case 1 over the index skips the sort of the GROUP BY; result = the rows of Case 1';
--@queryplan
select ka, kb, count(distinct v) as cnt_d, median(v) as med, percentile_cont(0.25) within group (order by v) as pct, group_concat(v order by v) as gc, count(v) as cnt, sum(v) as sm from t_roll force index (i_roll) where ka > 0 group by ka, kb with rollup order by ka, kb;

drop table t_roll;
