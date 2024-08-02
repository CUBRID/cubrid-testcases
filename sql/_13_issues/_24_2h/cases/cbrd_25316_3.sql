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
create table tbl_a (col_a int, c_r float, c_r_nl float, c_r_merge float, index idx_a (col_a));
create table tbl_b (col_a int, col_b int, c_r float, index idx_b (col_b));

insert into tbl_a
with recursive cte (n) as (
    select 1
    union all
    select n + 1 from cte where n < 10
  )
select n, null, null, null from cte;
insert into tbl_b select a.col_a, b.col_a, null from tbl_a a, tbl_a b where b.col_a <= a.col_a;

update statistics on tbl_a with fullscan;
update statistics on tbl_b with fullscan;


select 'The UPDATE JOIN statement allow the use of analytic functions With subquery.' as "test case 3";

select '' as "test case3: use avg";
update /*+ recompile */ tbl_a a set a.c_r = (select avg(b.col_a) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use count";
update /*+ recompile */ tbl_a a set a.c_r = (select count(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use sum";
update /*+ recompile */ tbl_a a set a.c_r = (select sum(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use min";
update /*+ recompile */ tbl_a a set a.c_r = (select min(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use max";
update /*+ recompile */ tbl_a a set a.c_r = (select max(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use stddev";
update /*+ recompile */ tbl_a a set a.c_r = (select stddev(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use stddev_pop";
update /*+ recompile */ tbl_a a set a.c_r = (select stddev_pop(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use stddev_samp";
update /*+ recompile */ tbl_a a set a.c_r = (select stddev_samp(b.col_b ) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use var_pop";
update /*+ recompile */ tbl_a a set a.c_r = (select var_pop(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use var_samp";
update /*+ recompile */ tbl_a a set a.c_r = (select var_samp(b.col_b) over (partition by b.col_a) from tbl_a a tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use variance";
update /*+ recompile */ tbl_a a set a.c_r = (select variance(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use ntile";
update /*+ recompile */ tbl_a a set a.c_r = (select ntile(4) over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use median";
update /*+ recompile */ tbl_a a set a.c_r = (select median(b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use first_value";
update /*+ recompile */ tbl_a a set a.c_r = (select first_value(b.col_b) over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use last_value";
update /*+ recompile */ tbl_a a set a.c_r = (select last_value(b.col_b) over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use nth_value";
update /*+ recompile */ tbl_a a set a.c_r = (select nth_value(b.col_b, 1) over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use lead";
update /*+ recompile */ tbl_a a set a.c_r = (select lead(b.col_b, 1, 0) over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use lag";
update /*+ recompile */ tbl_a a set a.c_r = (select lag(b.col_b, 1, 0) over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use row_number";
update /*+ recompile */ tbl_a a set a.c_r = (select row_number() over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use rank";
update /*+ recompile */ tbl_a a set a.c_r = (select rank() over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use dense_rank";
update /*+ recompile */ tbl_a a set a.c_r = (select dense_rank() over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use cume_dist";
update /*+ recompile */ tbl_a a set a.c_r = (select cume_dist() over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use percent_rank";
update /*+ recompile */ tbl_a a set a.c_r = (select percent_rank() over (partition by b.col_a order by b.col_b) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use percentile_cont";
update /*+ recompile */ tbl_a a set a.c_r = (select percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use percentile_disc";
update /*+ recompile */ tbl_a a set a.c_r = (select percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) from tbl_a a, tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r), if(isnull(c_r)=0, 'pass', 'fail') from tbl_a order by col_a;

drop table tbl_a;
drop table tbl_b;
