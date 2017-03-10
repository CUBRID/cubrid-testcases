drop table if exists t1;
create table t1(a int);
insert into t1 values (1);
insert into t1 values (2);
with cte (a, n) as (
    select a, 'x' from t1
    union all
    select cte.a + 1, 'y' from t1 inner join cte on cte.a<10
) 
select a,n, count(*) from cte group by a ,n order by 1;


with cte (a, n) as (
select a, 'x' from t1
union all
select cte.a + 1, 'y' from cte inner join t1 on cte.a<10) 
select a,n, count(*) from cte group by a ,n; 
drop table if exists t1;


