--[Analytic Functions] 'The argument of "MEDIAN" can not be coerced to desired domain "DOUBLE, DATETIME, TIME"' error occurs when selecting multiple analytic functions.


drop table if exists af;
create table af(
col1 int,
col2 int,
col3 char(20),
col4 int
);

insert into af values(1, 1, 'cubrid', 1);
insert into af values(1, 1, 'cubrid', 1);

select
avg(col1) over(partition by col3) a,
cume_dist() over(partition by col4 order by col3) b,
min(col2) over(partition by col4 order by col3, col1) c,
median(col1) over(partition by col3, col4) d,
stddev(col1) over(partition by col3, col4 order by col2) e
from af order by 1;

select cume_dist() over(partition by col4 order by col3) b, min(col2) over(partition by col4 order by col3, col1) c, median(col1) over(partition by col3, col4) d from af order by 1;

drop table af;

drop table if exists t1;
create table t1(a int, b int, c varchar(10), d varchar(10));
insert into t1 values(1,1,'123','123'),(2,2,'234','234');

select median(c) over (partition by a), median(d) over (partition by a), median(a) over (partition by a), median(b) over (partition by a) , median(c) over (), median(d) over(), median(a) over (), median(b) over () from t1 order by 1, 2, 3;

select median(a) over (partition by a,b) a, median(a) over (partition by a,b,c) b from t1 order by 1, 2;

drop table t1;
