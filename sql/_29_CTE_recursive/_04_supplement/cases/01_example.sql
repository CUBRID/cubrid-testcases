set @x=1;
with recursive cte as 
(
select @x as n 
union all 
select n+1 from cte  where n<10 
) 
select * from cte order by 1limit 10;

with recursive cte as
(
select @x as n
union all 
select n+1 from cte  where n<10
)
select * from cte order by 1 limit 10;

set @y=1000;
with recursive cte as 
(
select @y as a union all select a-1 from cte where a>0
) 
select * from cte order by 1  limit 10;  
drop variable @x;
drop variable @y;
