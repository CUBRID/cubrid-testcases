drop table if exists foo ;

create table foo(a int);

insert into foo values(1);
insert into foo values(1);
insert into foo values(1);
insert into foo values(2);
insert into foo values(2);

select a, row_number() over(partition by null order by a) row_num from foo;

drop table if exists foo ;

create table t (i int, j int, k int);
insert into t values (1, 1, 1);
insert into t values (1, 2, 2);
insert into t values (1, 3, 3);
insert into t values (2, 1, 1);
insert into t values (2, 2, 2);

select row_number() over (partition by null) from t;
select row_number() over (order by null) from t;

select rank() over (partition by null) from t;
select rank() over (order by null) from t;

select dense_rank() over (partition by null) from t;
select dense_rank() over (order by null) from t;

select row_number() over (partition by null order by null) from t;
select row_number() over (partition by null, i, null order by null, j, null) from t;
select row_number() over (partition by i, null, null order by j, null, null) from t;
select row_number() over (partition by null, null, i order by null, null, j) from t;
select row_number() over (partition by null, null, null order by null, null, null) from t;
select row_number() over (partition by null asc, null desc, null order by null desc, null, null asc) from t;

drop t;
