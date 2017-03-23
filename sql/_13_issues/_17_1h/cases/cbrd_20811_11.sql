with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, GROUP_CONCAT(f1) ,1 as f2 from cte group by f3
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1,GROUP_CONCAT(f1),1 as f2 from cte group by f3 having f1<5
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, GROUP_CONCAT(f1) ,1 as f2 from cte group by f3 having  GROUP_CONCAT(f1)=1
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, GROUP_CONCAT(f1) ,1 as f2 from cte group by f3 having  GROUP_CONCAT(f1)=2
)select * from cte order by 1,2;

