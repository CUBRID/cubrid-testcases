with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, FIRST_VALUE(f1) over(PARTITION BY f3),1 as f2 from cte 
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1,FIRST_VALUE(f1) over(PARTITION BY f3),1 as f2 from cte where f1<5
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select 2 , 2,2
union all
select f1+1,FIRST_VALUE(f1) over(PARTITION BY f3),1 as f2 from cte group by f3 having f1<5
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, VAR_SAMP(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1,VAR_SAMP(f1) over(PARTITION BY f3),1 as f2 from cte where f1<5
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select 2 , 2,2
union all
select f1+1,VAR_SAMP(f1) over(PARTITION BY f3),1 as f2 from cte group by f3 having f1<5
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, VAR_POP(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, STDDEV_SAMP(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, STDDEV_POP(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, ROW_NUMBER() over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, RANK() over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, PERCENT_RANK() over(PARTITION BY f3 order BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, NTILE(5) over(order BY f3),1 as f2 from cte
)select * from cte order by 1,2;


with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, NTH_VALUE(f1,2) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, MEDIAN(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, max(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, min(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1,  LEAD (f1, 1) over(order BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1,  LAG(f1, 1) over(order BY f3),1 as f2 from cte
)select * from cte order by 1,2;

with cte(f1,f2,f3) as(
select 1 , 1,1
union all
select f1+1, LAST_VALUE(f1) over(PARTITION BY f3),1 as f2 from cte
)select * from cte order by 1,2;
