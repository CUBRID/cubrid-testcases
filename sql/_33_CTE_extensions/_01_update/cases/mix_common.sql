drop if exists t,yoo;
create table t(empId int,fname varchar(20),sname varchar(20),bossId int);
insert into t values(10,'z','l',1);
insert into t values(2,'c','o',1);
insert into t values(1,'f','a',1);
create table yoo as
WITH cte(a,b,c,d) as (select empId , fname , sname , bossId
FROM t WHERE sname = 'o'
UNION all 
select e.empId , e.fname , e.sname , e.bossid
FROM t e inner JOIN cte r ON e.bossId= r.a)
SELECT *
FROM cte ;


select * from yoo;

WITH cte(a,b,c,d) as (select empId , fname , sname , bossId
FROM t WHERE sname = 'o'
UNION all
select e.empId , e.fname , e.sname , e.bossid
FROM t e inner JOIN cte r ON e.bossId= r.a)
update yoo set a=a+10 where c in (select c from cte);

select * from yoo;

WITH cte(a,b,c,d) as (select empId , fname , sname , bossId
FROM t WHERE sname = 'o'
UNION all
select e.empId , e.fname , e.sname , e.bossid
FROM t e inner JOIN cte r ON e.bossId= r.a)
delete from yoo where c in (select c from cte) ;

select * from yoo;


WITH cte(a,b,c,d) as (select empId , fname , sname , bossId
FROM t WHERE sname = 'o'
UNION all
select e.empId , e.fname , e.sname , e.bossid
FROM t e inner JOIN cte r ON e.bossId= r.a)
delete from yoo where c in (select c from cte) select * from cte;




