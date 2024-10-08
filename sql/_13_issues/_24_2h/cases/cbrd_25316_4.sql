-- This test case verifies CBRD-25316 issue.
-- Analytic functions can be used in an UPDATE statement when only one table is involved in the query.
-- Analytic functions cannot be used in an UPDATE JOIN statement when two or more tables are involved in the query.
-- Verifies Analystic functions and hints that are related to join method(use_nl, use_merge) only.
/* ----------------------------------------
 *
 * Analytic function
 *
 * reserved_func
 *   | COUNT '(' '*' ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | COUNT '(' of_distinct_unique expression_ ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | COUNT '(' opt_all expression_ ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic '(' of_distinct_unique expression_ ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic '(' opt_all expression_ ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic_first_last '(' expression_ ')' opt_analytic_ignore_nulls OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic_nth_value '(' expression_ ',' expression_ ')' opt_analytic_from_last opt_analytic_ignore_nulls OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic_lead_lag '(' expression_ ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic_lead_lag '(' expression_ ',' expression_ ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic_lead_lag '(' expression_ ',' expression_ ',' expression_ ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_analytic_no_args '(' ')' OVER '(' opt_analytic_partition_by opt_analytic_order_by ')'
 *   | of_percentile '(' expression_ ')' WITHIN GROUP_ '(' ORDER BY sort_spec ')' opt_over_analytic_partition_by
 *
 * of_analytic
 *   : avg
 *   | max
 *   | min
 *   | sum
 *   | stddev
 *   | stddev_pop
 *   | stddev_samp
 *   | var_pop
 *   | var_samp
 *   | variance
 *   | ntile
 *   | median
 *
 * of_analytic_first_last
 *   : FIRST_VALUE
 *   | LAST_VALUE
 *
 * of_analytic_nth_value
 *   : NTH_VALUE
 *
 * of_analytic_lead_lag
 *   : LEAD
 *   | LAG
 *
 * of_analytic_no_args
 *   : ROW_NUMBER
 *   | RANK
 *   | DENSE_RANK
 *   | CUME_DIST
 *   | PERCENT_RANK
 *
 * of_percentile
 *   : PERCENTILE_CONT
 *   | PERCENTILE_DISC
 *
 * ---------------------------------------- */

select '' as "test data";
drop table if exists tbl_a, tbl_b;
create table tbl_a (col_a int, c_r varchar, index idx_a (col_a));
create table tbl_b (col_a int, col_b int, c_r varchar, index idx_b (col_a, col_b));

insert into tbl_a (col_a) values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
insert into tbl_b select a.col_a, b.col_a, null from tbl_a a, tbl_a b where b.col_a <= a.col_a;
insert into tbl_b values (1, 1, null), (1, 2, null), (1, 3, null);

update statistics on tbl_a, tbl_b with fullscan;

select 'The UPDATE JOIN statement allow the use of analytic functions With inline view.' as "test case 4";

select '' as "test case4: use avg";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, avg (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use count";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, count (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use sum";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, sum (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use min";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, min (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use max";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, max (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use stddev";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, stddev (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use stddev_pop";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, stddev_pop (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use stddev_samp";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, stddev_samp (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use var_pop";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, var_pop (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use var_samp";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, var_samp (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use variance";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, variance (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use ntile";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, ntile (4) over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use median";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, median (b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use first_value";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, first_value (b.col_b) over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use last_value";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, last_value (b.col_b) over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use nth_value";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, nth_value (b.col_b, 1) over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use lead";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, lead (b.col_b, 1, -1) over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use lag";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, lag (b.col_b, 1, -1) over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use row_number";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, row_number () over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use rank";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, rank () over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use dense_rank";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, dense_rank () over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use cume_dist";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, cume_dist () over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use percent_rank";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, percent_rank () over (partition by b.col_a order by b.col_b) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use percentile_cont";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, percentile_cont (0.5) within group (order by b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

select '' as "test case4: use percentile_disc";
update /*+ recompile */
  tbl_a a,
  (
    select t.col_a, group_concat (t.c_r) as c_r
    from (select distinct b.col_a, percentile_disc (0.5) within group (order by b.col_b) over (partition by b.col_a) as c_r from tbl_b b) t
    group by t.col_a
  ) t
set a.c_r = t.c_r
where a.col_a = t.col_a;
select col_a, c_r from tbl_a order by col_a;

drop table tbl_a;
drop table tbl_b;
