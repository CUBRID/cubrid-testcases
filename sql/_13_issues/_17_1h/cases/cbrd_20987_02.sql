
drop table if exists x,y,z,s,r;
CREATE table x(a INT PRIMARY KEY, b INT);
insert into x values(1,1);
insert into x values(2,1);
insert into x values(4,1);
CREATE table y(a INT PRIMARY KEY, b INT, c INT);
insert into y values(1,3,1);
insert into y values(2,1,1);
insert into y values(3,2,1);
CREATE table z(b INT PRIMARY KEY, d INT);
insert into z values(3,1);
insert into z values(4,1);
insert into z values(1,1);
CREATE table s(a INT PRIMARY KEY, b INT, c INT,d INT);
insert into s values(2,3,2,1);
insert into s values(3,3,1,1);
insert into s values(5,4,1,1);
CREATE table r(a INT );
insert into r values(2);
insert into r values(3);
insert into r values(5);

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(*) from s inner join cte on s.c=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(s.*) from s inner join cte on s.c=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(s.a) from s inner join cte on s.c=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(cte.*) from s inner join cte on s.c=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(cte.f1) from s inner join cte on s.c=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(*) from r inner join cte on s.c=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(cte.*) from r inner join cte on s.c=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(r.*) from r inner join cte on r.a=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(r.a) from r inner join cte on r.a=cte.f1;

with cte(f1) as (
select x.a from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(cte.f1) from r inner join cte on r.a=cte.f1;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select avg(s.a) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select avg(cte.f1) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(cte.*) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(s.*) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(cte.f7) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (

select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(w.*) from (with tmp as (select * from s) select * from tmp) w inner join cte on w.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (

select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(*) from (with tmp as (select * from s) select * from tmp) w inner join cte on w.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (

select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(w.c) from (with tmp as (select c from s) select c from tmp) w inner join cte on w.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (

select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(w.*) from (with tmp as (select c from s) select c from tmp) w inner join cte on w.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (

select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(w.c) from (with tmp as (select c from s) select c from tmp) w inner join cte on w.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (

select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(w.*) from (with tmp as (select c from s) select c from tmp) w inner join cte on w.c=cte.f2;


with cte(f1,f2,f3,f4,f5,f6,f7) as (

select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(cte.*) from (with tmp as (select * from s) select * from tmp) w inner join cte on w.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(cte.f1) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select max(cte.f1) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(cte.f1) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select sum(cte.*) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(s.*) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(s.a) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select count(cte.*) from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4,f5,f6,f7) as (
select * from x,y,z where x.a=y.a and x.b=y.b and y.b=z.b and y.c=z.d
)
select cte.* from s inner join cte on s.c=cte.f2;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select count(*) from s inner join cte on s.d=cte.f1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select * from s inner join cte on s.d=cte.f1 order by 1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select count(s.*) from s inner join cte on s.d=cte.f1;

with cte(f1,f2,f3,f4) as (
select * from x,z where x.a=z.b 
)
select count(cte.*) from s inner join cte on s.d=cte.f1;
drop table if exists x,y,z,s,r;
