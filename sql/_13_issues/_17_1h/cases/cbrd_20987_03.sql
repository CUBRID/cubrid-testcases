drop if exists x,y,z,x_y_z;
CREATE CLASS x(a INT PRIMARY KEY, b INT);
insert into x values(1,1);
insert into x values(2,1);
insert into x values(4,1);
CREATE CLASS y(a INT PRIMARY KEY, b INT, c INT);
insert into y values(1,3,1);
insert into y values(2,1,1);
insert into y values(3,2,1);
CREATE CLASS z(b INT PRIMARY KEY, d INT);
insert into z values(3,1);
insert into z values(4,1);
insert into z values(1,1);
CREATE CLASS x_y_z UNDER x, y, z INHERIT a OF x, b OF y;
insert into x_y_z values(3,3,1,1);
insert into x_y_z values(5,4,1,1);
with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(*) from x_y_z inner join cte on x_y_z.c=cte.f2;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select count(cte.*) from x_y_z inner join cte on x_y_z.d=cte.f1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select count(x_y_z.*) from x_y_z inner join cte on x_y_z.d=cte.f1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select max(x_y_z.*) from x_y_z inner join cte on x_y_z.d=cte.f1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select max(cte.*) from x_y_z inner join cte on x_y_z.d=cte.f1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select max(cte.f1) from x_y_z inner join cte on x_y_z.d=cte.f1;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select cte.* from x_y_z inner join cte on x_y_z.c=cte.f2 order by 1;

ALTER CLASS x_y_z DROP SUPERCLASS y INHERIT b OF x;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select count(*) from x_y_z inner join cte on x_y_z.d=cte.f1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select * from x_y_z inner join cte on x_y_z.d=cte.f1 order by 1;

drop if exists x,y,z,x_y_z;
