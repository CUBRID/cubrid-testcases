drop if exists t;
create table t(empId int,fname varchar(20),sname varchar(20),bossId int);
insert into t values(10,'z','l',1);
insert into t values(2,'c','o',1);
insert into t values(1,'f','a',1);

WITH cte(a,b,c,d) as (select empId , fname , sname , bossId
FROM t WHERE sname = 'o'
UNION all
select e.empId , e.fname , e.sname , e.bossid
FROM t e inner JOIN cte r ON ( e.bossId= r.a))
SELECT c,b
FROM cte; SELECT *
FROM t order by 1;

WITH cte(a,b,c,d) as (select empId , fname , sname , bossId
FROM t WHERE sname = 'o'
UNION all
select e.empId , e.fname , e.sname , e.bossid
FROM t e inner JOIN cte r ON ( e.bossId= r.a))
SELECT c,b
FROM cte SELECT c,b
FROM cte ;
drop if exists t;

