drop table if exists x1;

create table x1(a int, b int);
insert into x1 values (1, 1);
insert into x1 values (2, 1);
--test: result is not correct.
SELECT distinct z1.*, row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2 order by 1;

SELECT distinct z1.a, row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2 order by 1;

SELECT distinct z1.b, row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2 order by 1;

SELECT distinct row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2 order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2,x1 z3,x1 z4 order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1 inner join  x1 z2 on z1.a=z2.a order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1 left  join  x1 z2 on z1.a=z2.a order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1 right  join  x1 z2 on z1.a=z2.a order by 1;


drop table if exists x1;
create table x1(a varchar(1), b char(1));
insert into x1 values (1, 1);
insert into x1 values (2, 1);
--test: result is not correct.
SELECT distinct z1.*, row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2  order by 1;

SELECT distinct z1.a, row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2 order by 1;

SELECT distinct z1.b, row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2  order by 1;

SELECT distinct row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2 order by 1;

SELECT distinct 1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2 order by 1;

SELECT distinct 1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2,x1 z3  order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2,x1 z3,x1 z4   order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1 inner join  x1 z2 on z1.a=z2.a  order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1 left  join  x1 z2 on z1.a=z2.a  order by 1;

SELECT distinct  1+1,  row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1 right  join  x1 z2 on z1.a=z2.a order by 1;

(SELECT distinct row_number() over (partition by z2.a,z1.a order by z2.b) c11 
FROM x1 z1, x1 z2) union all (SELECT distinct row_number() over (partition by z2.a,z1.a order by z2.b) c11 FROM x1 z1, x1 z2) order by 1;

drop table x1;