--test syntax correctness, param validness of the arguments

drop table if exists t;

create table t(a int, b int);
insert into t values(1, 1);
insert into t values(2, 1);

--test: syntax correctness of the function as aggregate/analytic function
--[er] syntax error of aggregate function
select percentile_disc(0.5) from t;
select percentile_disc(0.2) within group() from t;
select percentile_disc(0.8) within group(a) from t;
select percentile_disc(5.500000000000000e-01) within group(partition by a) from t;

--[er] syntax error of analytic function
select percentile_disc(0.5) over() from t;
select percentile_disc(0.5) within group(order by a) over() from t;
select percentile_disc(3.500000000000000e-01) within group(order by a) over() from t;
select percentile_disc(0.5) within group(order by a) over(order by a) from t;
select percentile_disc(0.5) within group(order by a) over(partition by a order by a) from t;

--test: pass out-of-range value to the first param
select percentile_disc(1.1) within group(order by a) from t;
select percentile_disc(100) within group(order by a) from t;
select percentile_disc(-1) within group(order by a) from t;
select percentile_disc(1.1) within group(order by a) over(partition by a) from t;
select percentile_disc(100) within group(order by a) over(partition by a) from t;
select percentile_disc(-1) within group(order by a) over(partition by a) from t;

--test: pass incompatible number of arguments to the function
select percentile_disc(0.3, 0.5) within group(order by a) from t;
select percentile_disc(0.3) within group(order by a, b) from t;
select percentile_disc(0.3, 0.5) within group(order by a) over(partition by a) from t;
select percentile_disc(3.500000000000000e-01, 5.500000000000000e-01) within group(order by a) over(partition by a) from t;
select percentile_disc(0.3) within group(order by a, b) over(order by b) from t;

--test: pass null to the params
select percentile_disc(null) within group(order by a) p_cont from t;
select percentile_disc(0.5) within group(order by null) p_cont from t;

drop table t;

