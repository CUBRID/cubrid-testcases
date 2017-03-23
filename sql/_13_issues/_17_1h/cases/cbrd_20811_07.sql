with cte as (
select '1' f1,'1' f2
union
select '1' f1,'1' f2
union
select '2' f1,'1' f2
union all
SELECT LEFT('CUBRID', 3),right('CUBRID', 3) 
)select * from cte order by 1,2;

with cte as (
select '1' f1,'1' f2
union
select '1' f1,'1' f2
union
select '2' f1,'1' f2
union all
SELECT LEFT('CUBRID', 3),right('CUBRID', 3) from cte
)select * from cte order by 1,2;

with cte as (
select 'a' as f1,'A' as f2,1 as f3
union all
SELECT f1||f3,f2||f3,f3+1 from cte where f1=LEFT('a111111111111111111111111111111111111', 10)
)select * from cte order by 1,2;

with cte(f1,f2,f3) as (
select 'a' as f1,'A' as f2,1 as f3 from db_root
union all
SELECT f1||f3,f2||f3,f3+1 from cte where f3<10
)select * from cte order by 1,2,3;
with cte(f1,f2,f3) as (
select 'a' as f1,'A' as f2,1 as f3 from db_root
union all
SELECT f1||f3,f2||f3,f3+1 from cte where f1='a123456789'
)select * from cte order by 1,2,3;
with cte(f1,f2,f3) as (
select 'a' as f1,'A' as f2,1 as f3 from db_root
union all
SELECT f1||f3,f2||f3,f3+1 from cte where f1 =left('a1234567891011121314151617',10)
)select * from cte order by 1,2,3;

with cte(f1,f2,f3) as (
select 'a' as f1,'A' as f2,1 as f3 from db_root
union all
SELECT f1||f3,f2||f3,f3+1 from cte where f1 <left('a1234567891011121314151617',10)
)select * from cte order by 1,2,3;

with cte(f1,f2,f3) as (
select 'a' as f1,'A' as f2,1 as f3 from db_root
union all
SELECT f1||f3,f2||f3,f3+1 from cte where f1 <right('a1234567891011121314151617',50)
)select * from cte order by 1,2,3;
with cte(f1,f2,f3) as (
select 'a' as f1,'A' as f2,1 as f3 from db_root
union all
SELECT f1||f3,f2||f3,f3+1 from cte where f1 =right('a1234567891011121314151617',50)
)select * from cte order by 1,2,3;




