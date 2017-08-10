--TEST: [Analytic Functions] Core dumped when using 'partition by [column_name] order by [position]' in over() clause of an analytic function.

drop table if exists t;

create table t(a int);
insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);

-- on some machines, crash occured after second run
select a, row_number() over(partition by a order by 1, 2) row_num from t;
select a, row_number() over(partition by a order by 1, 2) row_num from t;
select a, row_number() over(partition by a order by 1, 2) row_num from t;
select a, row_number() over(partition by a order by 1, 2) row_num from t;

drop table t;


create table t (i int, j int, k int);
insert into t values (1, 1, 1);
insert into t values (1, 2, 2);
insert into t values (1, 3, 3);
insert into t values (2, 1, 4);
insert into t values (2, 2, 5);

-- all should fail
select row_number() over (order by 1) from t;
select row_number() over (partition by 1) from t;
select row_number() over (partition by i order by 1) from t;
select row_number() over (partition by 1 order by i) from t;

select row_number() over (order by row_number() over ()) from t;
select row_number() over (order by avg(j) over ()) from t;

select row_number() over (), avg(i) over (partition by 1) from t;
select row_number() over (), avg(i) over (order by 1) from t;

select i + row_number() over (), avg(i) over (partition by 1) from t;
select i + row_number() over (), avg(i) over (order by 1) from t;

select avg(i) over (partition by 2), i + row_number() over () from t;
select avg(i) over (order by 2), i + row_number() over () from t;

drop table t;
