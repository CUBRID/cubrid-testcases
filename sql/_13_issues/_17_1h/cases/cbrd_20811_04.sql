drop if exists t;
create table t(id int);
insert into t values(1);
with cte as (
select 1 as id
union all
select cte.* from t
inner join cte on t.id=cte.id
)select * from cte order by 1;
with cte as (
select 1 as id
union all
select cte.id from t
inner join cte on t.id=cte.id
)select * from cte order by 1;
with cte as (
select 1 as c1
union all
select cte.* from t
inner join cte on t.id=cte.c1
)select * from cte order by 1;
with cte as (
select 1 as c1
union all
select cte.c1 from t
inner join cte on t.id=cte.c1
)select * from cte order by 1;
drop if exists t;
