drop table if exists x;
create table x(a int,b int,c int,d int,e int);
insert into x values(1,1,1,1,1);
with recursive tab(a,b,c,d,e) as (
select * from x
) 
insert into x(a,b,c,d,e)
select * from tab;
drop table if exists x;
