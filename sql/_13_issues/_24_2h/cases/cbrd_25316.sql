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

set optimization level 513;


select 'The UPDATE statement allows the use of analytic functions.' as "test case 1";
select '' as "test case1: use avg";
update /*+ recompile */ tbl_b b set b.c_r = avg (b.col_b) over (partition by b.col_a);
select distinct col_a, to_char (c_r) from tbl_b order by col_a;
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
select '' as "test case1: use row_number";
update /*+ recompile */ tbl_b b set b.c_r = row_number() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use rank";
update /*+ recompile */ tbl_b b set b.c_r = rank() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use dense_rank";
update /*+ recompile */ tbl_b b set b.c_r = dense_rank() over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use lead";
update /*+ recompile */ tbl_b b set b.c_r = lead(b.col_b, 1) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;
select '' as "test case1: use lag";
update /*+ recompile */ tbl_b b set b.c_r = lag(b.col_b, 1) over (partition by b.col_a order by b.col_b);
select distinct col_a, to_char(c_r) from tbl_b order by col_a;


select 'The UPDATE JOIN statement does not allow the use of analytic functions.' as "test case 2";
select '' as "test case2: use avg";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = avg(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = avg(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use count";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = count(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = count(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use sum";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = sum(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = sum(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use min";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = min(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = min(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use max";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = max(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = max(b.col_b) over (partition by b.col_a) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use row_number";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = row_number() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = row_number() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use rank";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use dense_rank";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = dense_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = dense_rank() over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use lead";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = lead(b.col_b, 1) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = lead(b.col_b, 1) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;
select '' as "test case2: use lag";
update /*+ recompile use_nl */ tbl_a a, tbl_b b set a.c_r_nl = lag(b.col_b, 1) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, tbl_b b set a.c_r_merge = lag(b.col_b, 1) over (partition by b.col_a order by b.col_b) where a.col_a = b.col_a;
select col_a, to_char(c_r_nl), to_char(c_r_merge), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;


select 'The UPDATE JOIN statement does not allow the use of analytic functions With subquery.' as "test case 3";
update /*+ recompile use_nl */ tbl_a a set a.c_r_nl = (select avg (b.col_b) over (partition by b.col_a) from tbl_b b where a.col_a = b.col_a limit 1);
select col_a, to_char (c_r) from tbl_a order by col_a;

select col_a, to_char(c_r_nl), if (nvl(c_r_nl, 0) = nvl(c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;


select 'The UPDATE JOIN statement does not allow the use of analytic functions With inline view.' as "test case 4";
update /*+ recompile use_nl */ tbl_a a, (select b.col_a, avg (b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_nl = b.col_b where a.col_a = b.col_a;
update /*+ recompile use_merge */ tbl_a a, (select b.col_a, avg (b.col_b) over (partition by b.col_a) col_b from tbl_b b) b set a.c_r_merge = b.col_b where a.col_a = b.col_a;
select col_a, to_char (c_r_nl), to_char (c_r_merge), if (nvl (c_r_nl, 0) = nvl (c_r_merge, 0), 'pass', 'no pass') from tbl_a order by col_a;

drop table tbl_a;
drop table tbl_b;
