drop table if exists x;
create table x(a int,b int,c int,d int,e int); 
insert into x values(1,1,1,1,1);
select y.* from (with recursive cte as (select * from x union all select a+1,b,c,d,e from cte where a<5 )select * from cte ) y;
drop table if exists x;
