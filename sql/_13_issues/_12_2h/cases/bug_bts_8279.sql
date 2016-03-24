--TEST: [Analytic Functions] Result is incorrect when inserting with 2 or more avg() analytic functions.

drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int);
insert into t1 values(1, 2);
insert into t1 values(10, 20);
insert into t1 values(100, 200);

create table t2(a int, b int);
insert into t2 select avg(a) over(), avg(a) over() from t1;
select * from t2 order by 1;
drop table t2;


create table t2(a int, b int, c int, d int);
insert into t2 select avg(a) over(), avg(a) over(), avg(a) over(order by b), avg(b) over(partition by a) from t1;
select * from t2 order by 1, 2, 3;
drop table t2;


create table t2(a int, b int, c int, d int);
insert into t2 select sum(a) over(), sum(a) over(), avg(a) over(order by b), avg(b) over(partition by a) from t1;
select * from t2 order by 1, 2, 3;
drop table t2;


create table t2(a int, b int, c int, d int);
insert into t2 select count(a) over(), avg(a) over(), sum(a) over(order by b), rank() over(partition by a) from t1;
select * from t2 order by 1, 2, 3;
drop table t2;

drop table t1;

