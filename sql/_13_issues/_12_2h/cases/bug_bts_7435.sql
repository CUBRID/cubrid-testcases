--TEST: [Analytic Functions] Result of stddev(numeric) analytic function is displayed as 'nan' when partitioned by a numeric column.


drop table if exists foo;

create table foo(a numeric(5, 2));
insert into foo values(1.01), (12.02), (12.02), (12.02);


select stddev(a) over(partition by a) from foo order by 1;
select stddev_samp(a) over(partition by a) from foo order by 1;
select stddev_pop(a) over(partition by a) from foo order by 1;
select var_pop(a) over(partition by a) from foo order by 1;
select var_samp(a) over(partition by a) from foo order by 1;
select variance(a) over(partition by a) from foo order by 1;


select stddev(a) over(partition by a order by a) from foo order by 1;
select stddev_samp(a) over(partition by a order by a) from foo order by 1;
select stddev_pop(a) over(partition by a order by a) from foo order by 1;
select var_pop(a) over(partition by a order by a) from foo order by 1;
select var_samp(a) over(partition by a order by a) from foo order by 1;
select variance(a) over(partition by a order by a) from foo order by 1;


drop table foo;
