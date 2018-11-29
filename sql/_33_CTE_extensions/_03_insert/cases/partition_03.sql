drop table if exists t;
create table t(i int unique)
partition by list(i)
(
partition before_2000 values in (1,3,5,7),
partition before_4000 values in (2,4,6,8)
);
insert into t values(1),(8);

drop table if exists foo;
create table foo as
with cte as
(  select * from t where i<5),
cte1 as
( select * from t where i>5)
select * from cte
union all
select * from cte1;

select * from foo order by 1;

alter table foo change column i i int unique;

replace into foo
with cte as
(  select * from t where i<5),
cte1 as
( select * from t where i>5)
select * from cte
union all
select * from cte1;

select * from foo order by 1;


insert into foo
with cte as
(  select * from t where i<5),
cte1 as
( select * from t where i>5)
select * from cte
union all
select * from cte1 on duplicate key update i=i+1 ;

select * from foo order by 1;

--CBRD-22567
insert into foo
with cte as
(  select * from t where i<5),
cte1 as
( select * from t where i>5)
select i+1 from cte
union all
select i from cte1 on duplicate key update i=(select i-10 from cte);

insert into foo
with cte as
(  select * from t where i<5),
cte1 as
( select * from t where i>5)
select i+1 from cte
union all
select i from cte1 on duplicate key update i=i-10;

select * from foo order by 1;


insert into foo
with cte as
(  select * from t where i<5),
cte1 as
( select * from t where i>5)
select i+1 from cte
union all
select i from cte1 on duplicate key update i=(select i-12 from t where i<5);

select * from foo order by 1;

drop table if exists foo,t;
