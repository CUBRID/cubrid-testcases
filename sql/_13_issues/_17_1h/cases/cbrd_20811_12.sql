drop if exists t1;
create table t1(i int);
insert into t1 values(1);
insert into t1 values(1);
insert into t1 values(1);
with cte as (
select 2
union all
select distinct i from t1
) select * from cte order by 1;

with cte(f1,f2) as (
select 2,2
union all
select distinct f1,f2+1 from cte  where f2<5
) select * from cte order by 1,2;

with cte(f1,f2) as (
select 2,2
union all
select distinct f1,f2+1 from cte 
) select * from cte order by 1,2;

with cte(f1,f2) as (
select 2,2
union all
select distinct f1,f2 from cte
) select * from cte order by 1,2;

with cte(f1,f2) as (
select 2,2
union all
select distinct f1,2 from cte
) select * from cte order by 1,2;
drop if exists t1;

