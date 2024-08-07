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
create table tbl_a (col_a int, c_r float, index idx_a (col_a));
create table tbl_b (col_a int, col_b int, c_r float, index idx_b (col_b));

insert into tbl_a
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 10
  )
select n, null from cte;
insert into tbl_b select a.col_a, b.col_a, null from tbl_a a, tbl_a b where b.col_a <= a.col_a;
insert into tbl_b values (1, 1, null), (1, 2, null), (1, 3, null);

update statistics on tbl_a with fullscan;
update statistics on tbl_b with fullscan;


select '[error case] The UPDATE JOIN statement does not allow the use of analytic functions.' as "test case 2";

select '' as "test case2: use avg";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = avg(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use count";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = count(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use sum";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = sum(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use min";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = min(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use max";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = max(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use stddev";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = stddev(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use stddev_pop";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = stddev_pop(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use stddev_samp";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = stddev_samp(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use var_pop";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = var_pop(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use var_samp";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = var_samp(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use variance";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = variance(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use ntile";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = ntile(4) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use median";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = median(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use first_value";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = first_value(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use last_value";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = last_value(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use nth_value";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = nth_value(b.col_b, 2) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use lead";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = lead(b.col_b, 1, 0) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use lag";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = lag(b.col_b, 1, 0) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use row_number";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = row_number() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use rank";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use dense_rank";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = dense_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use cume_dist";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = cume_dist() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use percent_rank";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = percent_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select '' as "test case2: use percentile_cont";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select '' as "test case2: use percentile_disc";
update /*+ recompile */ tbl_a a, tbl_b b set a.c_r = percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;


drop table tbl_a;
drop table tbl_b;
