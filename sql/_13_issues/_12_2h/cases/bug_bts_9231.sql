--TEST: [Analytic Functions] ERROR: System error (generate order_by) in ../../src/parser/xasl_generation.c (line: 5451) occurs when order by a negative number in over() clause.

create table t(a int);

--[er]
select row_number() over(order by -1) from t;
select rank() over(partition by -100) from t;
select max(a) over(partition by abc order by 999999999999999999999999999999999999999) from t;
select stddev(a) over(partition by 9999999999999999999999999999999999) from t;


drop table t;
