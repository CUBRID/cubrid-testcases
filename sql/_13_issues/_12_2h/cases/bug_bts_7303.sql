--TEST: [Analytic Functions] No result is returned when row_number() function is selected in an IN expression.


drop table if exists foo;

create table foo(a int primary key, b int, c smallint);
insert into foo values(1, 2, 5);
insert into foo values(2, 3, 8);
insert into foo values(3, 1, 16);
insert into foo values(4, 3, 16);
insert into foo values(5, 1, 5);

select a, b, c from foo where a in (select row_number() over(partition by b order by a) row_num from foo) order by 1;

drop foo;


drop table if exists t;

create table t (i int, j int);
insert into t values (1, 1), (1, 2), (1, 2), (1, 3), (1, 4), (2, 1), (2, 2), (2, 3);

select distinct row_number() over (partition by i) from t order by 1;
select distinct row_number() over (partition by i order by j) from t order by 1;

select distinct avg(j) over () from t;
select distinct avg(j) over () from t order by 1;
select distinct j, avg(j) over () from t order by 1, 2;
select distinct avg(j) over (partition by i) from t order by 1;
select distinct j, avg(j) over (partition by i) from t order by 1, 2;
select distinct avg(i) over (partition by j order by i) from t order by 1;
select distinct i, avg(i) over (partition by j order by i) from t order by 1, 2;

select distinct sum(j) over () from t;
select distinct sum(j) over () from t order by 1;
select distinct j, sum(j) over () from t order by 1, 2;
select distinct sum(j) over (partition by i) from t order by 1;
select distinct j, sum(j) over (partition by i) from t order by 1, 2;

select distinct stddev_samp(j) over () from t;
select distinct stddev_samp(j) over () from t order by 1;
select distinct j, stddev_samp(j) over () from t order by 1, 2;
select distinct stddev_samp(j) over (partition by i) from t order by 1;
select distinct j, stddev_samp(j) over (partition by i) from t order by 1, 2;
select distinct stddev_samp(i) over (partition by j order by i) from t order by 1;
select distinct i, stddev_samp(i) over (partition by j order by i) from t order by 1, 2;

drop t;
