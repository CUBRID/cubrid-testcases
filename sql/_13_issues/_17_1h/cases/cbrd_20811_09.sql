with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1,count( distinct f1),1 as f2 from cte group by f3
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1,count( distinct f1),1 as f2 from cte group by f3 having f1<5
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select 2 , 2,2
union all
select f1+1,count( distinct f1),1 as f2 from cte group by f3 having f1<5
)select * from cte order by 1,2;
