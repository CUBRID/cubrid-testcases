drop table if exists x;
create table x(a int,b int,c int,d int,e int); 
insert into x values(1,1,1,1,1);
select y.* from (with cte as (select * from x)select * from cte ) y;
select y.a,y.b from (with cte as (select * from x)select * from cte ) y;
select y.*,z.* from (with cte as (select * from x)select * from cte ) y,(with cte as (select * from x)select * from cte )z;
select y.*,z.* from (with cte as (select * from x)select * from cte ) y,(with cte as (select * from x)select * from cte )z where y.a=z.b;
select y.*,z.* from (with cte as (select * from x)select * from cte ) y,(with cte as (select * from x)select * from cte )z order by 1 limit 1;
select * from (with cte as (select * from x)select * from cte );
select * from (with cte as (select * from x)select * from cte ),(with cte as (select * from x)select * from cte );
select a,b,c,d,e from (with cte as (select * from x)select * from cte );
select y.* from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte ) y order by 1;
select y.a,y.b,y.c,y.d,y.e from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte) y order by 1;
select y.* from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte
 order by 1) y;
select y.a,y.b from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte order by 1) y;

select * from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte
 ) order by 1;
select a,b,c,d,e from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte) order by 1;
select * from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte
 order by 1) ;
select a,b,c,d,e from (with recursive cte(a,b,c,d,e) as (select * from x union all select a+1,b+1,c+1,d+1,e+1 from cte where a<10)select * from cte order by 1) ;
drop table if exists x;

