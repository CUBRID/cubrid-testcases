drop if exists tree2,tree;
CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
INSERT INTO tree VALUES (1,NULL,'Kim', 1963);
INSERT INTO tree VALUES (2,NULL,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,6,'Brown', 1981);
CREATE TABLE tree2(id int, treeid int, job varchar(32));
INSERT INTO tree2 VALUES(1,1,'Partner');
INSERT INTO tree2 VALUES(2,2,'Partner');
INSERT INTO tree2 VALUES(3,3,'Developer');
INSERT INTO tree2 VALUES(4,4,'Developer');
INSERT INTO tree2 VALUES(5,5,'Sales Exec.');
INSERT INTO tree2 VALUES(6,6,'Sales Exec.');
INSERT INTO tree2 VALUES(7,7,'Assistant');
INSERT INTO tree2 VALUES(8,null,'Secretary');

with cte as (SELECT id, mgrid, name
FROM tree ) select * from cte
CONNECT BY PRIOR id=mgrid
ORDER BY id;

with  cte2 as (SELECT id, mgrid, name
FROM tree )
,cte as (SELECT id, mgrid, name
FROM tree ) select * from cte t
CONNECT BY PRIOR t.id=t.mgrid
ORDER BY t.id;

with  cte2 as (SELECT id, mgrid, name
FROM tree )
,cte as (SELECT id, mgrid, name
FROM tree ) select level from cte t
CONNECT BY PRIOR t.id=t.mgrid
ORDER BY level;

with cte as (SELECT id, mgrid, name
FROM tree
CONNECT BY PRIOR id=mgrid
ORDER BY id) select * from cte order by id;

with recursive cte as (SELECT id, mgrid, name
FROM tree
CONNECT BY PRIOR id=mgrid
ORDER BY id) select * from cte order by id;

with cte2 as (
select * from tree2 t2),
cte1 as (
SELECT t.id,t.mgrid,t.name,t2.job
FROM tree t,cte2 t2)
select * ,level from cte1 t inner join cte2 t2 ON t.id=t2.treeid
START WITH t.mgrid is null
CONNECT BY prior t.id=t.mgrid
ORDER BY t.id, t2.job, t.job limit 5;

with cte2 as (
select * from tree2 t2),
cte1 as (
SELECT t.id,t.mgrid,t.name,t2.job
FROM tree t,cte2 t2)
select * from cte1 t inner join cte2 t2 ON t.id=t2.treeid
CONNECT BY prior t.id=t.mgrid
ORDER BY t.id, t2.job, t.job limit 1;

with recursive cte2 as (
select * from tree2 t2),
cte1 as (
SELECT t.id,t.mgrid,t.name,t2.job
FROM tree t,cte2 t2)
select * from cte1 t inner join cte2 t2 ON t.id=t2.treeid
CONNECT BY prior t.id=t.mgrid
ORDER BY t.id, t2.job, t.job limit 1;

with  cte2 as (
select * from tree2 t2 limit 10),
cte1 as (
SELECT t.id,t.mgrid,t.name,t2.job,level
FROM tree t inner join cte2 t2 ON t.id=t2.treeid
START WITH t.mgrid is null
CONNECT BY prior t.id=t.mgrid
ORDER BY t.id)
select * from cte1 t inner join cte2 t2 ON t.id=t2.treeid
START WITH t.mgrid is null
CONNECT BY prior t.id=t.mgrid
ORDER BY t.id;

with  recursive cte2 as (
select * from tree2 t2 limit 10),
cte1 as (
SELECT t.id,t.mgrid,t.name,t2.job,level
FROM tree t inner join cte2 t2 ON t.id=t2.treeid
START WITH t.mgrid is null
CONNECT BY prior t.id=t.mgrid
ORDER BY t.id)
select * from cte1 t inner join cte2 t2 ON t.id=t2.treeid
START WITH t.mgrid is null
CONNECT BY prior t.id=t.mgrid
ORDER BY t.id;
drop if exists tree2,tree;
