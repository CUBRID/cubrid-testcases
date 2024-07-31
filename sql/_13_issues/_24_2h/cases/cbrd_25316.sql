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

select 'The UPDATE statement allows the use of analytic functions.' as "test case 1";

select '' as "test case1: use avg";
update /*+ recompile */ tbl_b b set b.c_r = avg(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use count";
update /*+ recompile */ tbl_b b set b.c_r = count(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use sum";
update /*+ recompile */ tbl_b b set b.c_r = sum(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use min";
update /*+ recompile */ tbl_b b set b.c_r = min(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use max";
update /*+ recompile */ tbl_b b set b.c_r = max(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use stddev";
update /*+ recompile */ tbl_b b set b.c_r = stddev(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use stddev_pop";
update /*+ recompile */ tbl_b b set b.c_r = stddev_pop(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use stddev_samp";
update /*+ recompile */ tbl_b b set b.c_r = stddev_samp(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use var_pop";
update /*+ recompile */ tbl_b b set b.c_r = var_pop(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use var_samp";
update /*+ recompile */ tbl_b b set b.c_r = var_samp(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use variance";
update /*+ recompile */ tbl_b b set b.c_r = variance(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use ntile";
update /*+ recompile */ tbl_b b set b.c_r = ntile(4) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use median";
update /*+ recompile */ tbl_b b set b.c_r = median(b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use first_value";
update /*+ recompile */ tbl_b b set b.c_r = first_value(b.col_b) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use last_value";
update /*+ recompile */ tbl_b b set b.c_r = last_value(b.col_b) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use nth_value";
update /*+ recompile */ tbl_b b set b.c_r = nth_value(b.col_b, 2) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use lead";
update /*+ recompile */ tbl_b b set b.c_r = lead(b.col_b) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use lag";
update /*+ recompile */ tbl_b b set b.c_r = lag(b.col_b) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use row_number";
update /*+ recompile */ tbl_b b set b.c_r = row_number() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use rank";
update /*+ recompile */ tbl_b b set b.c_r = rank() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use dense_rank";
update /*+ recompile */ tbl_b b set b.c_r = dense_rank() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use cume_dist";
update /*+ recompile */ tbl_b b set b.c_r = cume_dist() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use percent_rank";
update /*+ recompile */ tbl_b b set b.c_r = percent_rank() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use percentile_cont";
update /*+ recompile */ tbl_b b set b.c_r = percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use percentile_disc";
update /*+ recompile */ tbl_b b set b.c_r = percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;


select 'The UPDATE JOIN statement does not allow the use of analytic functions.' as "test case 2";

select '' as "test case2: use avg";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = avg(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = avg(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use count";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = count(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = count(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use sum";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = sum(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = sum(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use min";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = min(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = min(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use max";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = max(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = max(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use stddev";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = stddev(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = stddev(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use stddev_pop";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = stddev_pop(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = stddev_pop(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use stddev_samp";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = stddev_samp(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = stddev_samp(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use var_pop";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = var_pop(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = var_pop(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use var_samp";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = var_samp(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = var_samp(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use variance";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = variance(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = variance(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use ntile";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = ntile(4) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = ntile(4) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use median";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = median(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = median(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use first_value";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = first_value(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = first_value(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use last_value";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = last_value(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = last_value(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use nth_value";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = nth_value(b.col_b, 2) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = nth_value(b.col_b, 2) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use lead";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = lead(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = lead(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use lag";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = lag(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = lag(b.col_b) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use row_number";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = row_number() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = row_number() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use rank";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use dense_rank";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = dense_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = dense_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use cume_dist";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = cume_dist() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = cume_dist() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use percent_rank";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = percent_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = percent_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use percentile_cont";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case2: use percentile_disc";
update /*+ recompile use_nl / tbl_a a, tbl_b b set a.c_r_nl = percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;


select 'The UPDATE JOIN statement allow the use of analytic functions With subquery.' as "test case 3";

select '' as "test case3: use avg";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select avg(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select avg(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use count";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select count(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select count(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use sum";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select sum(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select sum(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use min";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select min(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select min(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use max";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select max(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select max(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use stddev";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select stddev(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select stddev(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use stddev_pop";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select stddev_pop(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select stddev_pop(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use stddev_samp";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select stddev_samp(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select stddev_samp(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use var_pop";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select var_pop(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select var_pop(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use var_samp";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select var_samp(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select var_samp(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use variance";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select variance(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select variance(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use ntile";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select ntile(4) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select ntile(4) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use median";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select median(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select median(b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use first_value";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select first_value(b.col_b) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select first_value(b.col_b) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use last_value";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select last_value(b.col_b) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select last_value(b.col_b) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use nth_value";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select nth_value(b.col_b, 1) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select nth_value(b.col_b, 1) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use lead";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select lead(b.col_b, 1) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select lead(b.col_b, 1) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use lag";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select lag(b.col_b, 1) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select lag(b.col_b, 1) over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use row_number";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select row_number() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select row_number() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use rank";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select rank() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select rank() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use dense_rank";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select dense_rank() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select dense_rank() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use cume_dist";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select cume_dist() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select cume_dist() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use percent_rank";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select percent_rank() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select percent_rank() over (partition by b.col_a order by b.col_b) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use percentile_cont";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case3: use percentile_disc";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
update /*+ recompile use_merge */ tbl_a a set a.c_r_merge = (select percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) =nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;


select 'The UPDATE JOIN statement allow the use of analytic functions With inline view.' as "test case 4";

select '' as "test case4: use avg";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, avg(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, avg(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use count";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, count(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, count(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use sum";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, sum(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, sum(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use min";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, min(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, min(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use max";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, max(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, max(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use stddev";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, stddev(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, stddev(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use stddev_pop";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, stddev_pop(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, stddev_pop(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use stddev_samp";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, stddev_samp(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, stddev_samp(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use var_pop";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, var_pop(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, var_pop(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use var_samp";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, var_samp(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, var_samp(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use variance";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, variance(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, variance(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use ntile";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, ntile(4) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, ntile(4) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use median";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, median(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, median(b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use first_value";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, first_value(b.col_b) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, first_value(b.col_b) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use last_value";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, last_value(b.col_b) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, last_value(b.col_b) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use nth_value";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, nth_value(b.col_b, 1) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, nth_value(b.col_b, 1) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use lead";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, lead(b.col_b, 1) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, lead(b.col_b, 1) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use lag";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, lag(b.col_b, 1) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, lag(b.col_b, 1) over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use row_number";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, row_number() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, row_number() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use rank";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, rank() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, rank() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use dense_rank";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, dense_rank() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, dense_rank() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use cume_dist";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, cume_dist() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, cume_dist() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use percent_rank";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, percent_rank() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, percent_rank() over (partition by b.col_a order by b.col_b) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use percentile_cont";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, percentile_cont(0.5) within group (order by b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;
select '' as "test case4: use percentile_disc";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, percentile_disc(0.5) within group (order by b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if(nvl(c_r_nl, 0) =nvl(c_r_merge, 0), 'pass', 'fail') from tbl_a order by col_a;


drop table tbl_a;
drop table tbl_b;
