drop table if exists t;
create table t(i int unique)
partition by range(i)
(
partition before_2000 values less than (2000),
partition before_4000 values less than (4000)
);
insert into t values(1999),(2001);

drop table if exists  x;
create table x(i int);
insert into x values(1999),(1);

drop table if exists foo;
create table foo as
with cte as
(  select * from t where i<2000),
cte1 as
( select * from t where i>2000)
select * from cte
union all
select * from cte1;

select * from foo;

alter table foo change column i i int unique;
insert into foo
with cte as
(  select * from t where i<2000),
cte1 as
( select * from t where i>2000)
select cte.i-100 from cte inner join x on cte.i=x.i;

select * from foo;

insert into foo
with cte as
(  select * from t where i<2000),
cte1 as
( select * from t where i>2000)
select cte.i from cte inner join x on cte.i=x.i
union all
select i from cte1 on duplicate key update i=i-1;

select * from foo;


insert into foo
with cte as
(  select * from t where i<2000),
cte1 as
( select * from t where i>2000)
select cte.i+1 from cte inner join x on cte.i=x.i
union all
select i from cte1 on duplicate key update i=(select i-10 from t where i<2000);

select * from foo;
