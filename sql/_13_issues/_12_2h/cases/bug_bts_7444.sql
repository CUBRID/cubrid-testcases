--TEST: [Analytic Functions] Result of stddev() analytic function is incorrect when there are null values in the column.

drop table if exists foo;
create table foo(a int);

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(null);

select stddev(a) from foo;
select a, stddev(a) over() from foo order by 1;
select a, stddev(a) over(order by a) from foo order by 1;
select a, stddev(a) over(partition by a order by a) from foo order by 1;

drop table foo;

drop table if exists t;

create table t (i int, j int);
insert into t values (1, 1);
insert into t values (1, 2);
insert into t values (1, null);
insert into t values (1, 4);
insert into t values (2, 1);
insert into t values (2, 2);
insert into t values (null, 3);
insert into t values (2, 4);

select count(j), count(*) from t order by i, j;
select i, j, count(j) over () as A, count(*) over () as B from t order by i, j;
select i, j, count(j) over (partition by i) as A, count(*) over (partition by i) as B from t order by i, j;

select stddev_pop(i), stddev_pop(j), var_pop(i), var_pop(j) from t order by i, j;
select i, j, stddev_pop(i) over () as A, stddev_pop(j) over () as B, var_pop(i) over () as C, var_pop(j) over () as D from t order by i, j;
select i, j, stddev_pop(i) over (partition by j) as A, stddev_pop(j) over (partition by i) as B, var_pop(i) over (partition by j) as C, var_pop(j) over (partition by i) as D from t order by i, j;

select avg(i), avg(j), sum(i), sum(j) from t order by i, j;
select i, j, avg(i) over () as A, avg(j) over () as B, sum(i) over () as C, sum(j) over () as D from t order by i, j;
select i, j, avg(i) over (partition by j) as A, avg(j) over (partition by i) as B, sum(i) over (partition by j) as C, sum(j) over (partition by i) as D from t order by i, j;

drop table t;


