set trace on;
--create table
drop table if exists tree;
drop table if exists tree2; 
CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
CREATE TABLE tree2(id int, treeid int, job varchar(32));
INSERT INTO tree VALUES (1,NULL,'Kim', 1963),(2,NULL,'Moy', 1958),(3,1,'Jonas', 1976),(4,1,'Smith', 1974),(5,2,'Verma', 1973),(6,2,'Foster', 1972),(7,6,'Brown', 1981);
INSERT INTO tree2 VALUES(1,1,'Partner'),(2,2,'Partner'),(3,3,'Developer'),(4,4,'Developer'),(5,5,'Sales Exec.'),(6,6,'Sales Exec.'),(7,7,'Assistant'),(8,null,'Secretary');

--general test case
SELECT id, mgrid, name FROM tree CONNECT BY PRIOR id=mgrid ORDER BY id;
show trace;
SELECT id, mgrid, name FROM tree CONNECT BY mgrid=PRIOR id ORDER BY id;
show trace;
SELECT t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id=t.mgrid ORDER BY t.id;
show trace;
SELECT t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY t.mgrid = prior t.id ORDER BY t.id;
show trace;

--with other predicate
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior (t.id+t.id)=t.mgrid;
show trace;
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id + t.id=t.mgrid;
show trace;
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id =t.mgrid and prior job = 'Partner';
show trace;
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id =t.mgrid and prior 1 = 1;
show trace;

--predicate with function
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior nvl (t.id,t.id+t.id)=t.mgrid;
show trace;
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior nvl (t.id,t.id+t.id)=decode(t.mgrid,null,t2.id-1,t.mgrid);
show trace;

--outer join
insert into tree values(8,6,'park',1981);
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t left outer JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id = t.mgrid;
show trace;
SELECT /*+ recompile */ t.id,t.name,t2.job,level FROM tree t ,tree2 t2 where t.id=t2.treeid(+) START WITH t.mgrid is null CONNECT BY prior t.id = t.mgrid;
show trace;

--different type : varchar 
drop table if exists tree;
drop table if exists tree2;
CREATE TABLE tree(ID INT, MgrID varchar(10), Name VARCHAR(32), BirthYear INT);
CREATE TABLE tree2(id int, treeid int, job varchar(32));
INSERT INTO tree VALUES (1,NULL,'Kim', 1963),(2,NULL,'Moy', 1958),(3,1,'Jonas', 1976),(4,1,'Smith', 1974),(5,2,'Verma', 1973),(6,2,'Foster', 1972),(7,6,'Brown', 1981);
INSERT INTO tree2 VALUES(1,1,'Partner'),(2,2,'Partner'),(3,3,'Developer'),(4,4,'Developer'),(5,5,'Sales Exec.'),(6,6,'Sales Exec.'),(7,7,'Assistant'),(8,null,'Secretary');
SELECT t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id=t.mgrid ORDER BY t.id;
show trace;
INSERT INTO tree VALUES (1,'p','Kim', 1963);
--should fail
SELECT t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id=t.mgrid ORDER BY t.id;
show trace;

--different type : nuemeric
drop table if exists tree; 
CREATE TABLE tree(ID INT, MgrID numeric(10,2), Name VARCHAR(32), BirthYear INT);
INSERT INTO tree VALUES (1,NULL,'Kim', 1963),(2,NULL,'Moy', 1958),(3,1,'Jonas', 1976),(4,1,'Smith', 1974),(5,2,'Verma', 1973),(6,2,'Foster', 1972),(7,6,'Brown', 1981);
SELECT t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id=t.mgrid ORDER BY t.id;
show trace;

--different type : int
drop table if exists tree; 
CREATE TABLE tree(ID numeric(10,2), MgrID INT, Name VARCHAR(32), BirthYear INT);
INSERT INTO tree VALUES (1,NULL,'Kim', 1963),(2,NULL,'Moy', 1958),(3,1,'Jonas', 1976),(4,1,'Smith', 1974),(5,2,'Verma', 1973),(6,2,'Foster', 1972),(7,6,'Brown', 1981);
SELECT t.id,t.name,t2.job,level FROM tree t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id=t.mgrid ORDER BY t.id;
show trace;

--memory limit
drop table if exists tree; 
drop table if exists tree2; 
drop table if exists tree3; 
CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
CREATE TABLE tree2(id int, treeid int, job varchar(32));
CREATE TABLE tree3(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT,gubun int);
INSERT INTO tree VALUES (1,NULL,'Kim', 1963),(2,NULL,'Moy', 1958),(3,1,'Jonas', 1976),(4,1,'Smith', 1974),(5,2,'Verma', 1973),(6,2,'Foster', 1972),(7,6,'Brown', 1981);
INSERT INTO tree2 VALUES(1,1,'Partner'),(2,2,'Partner'),(3,3,'Developer'),(4,4,'Developer'),(5,5,'Sales Exec.'),(6,6,'Sales Exec.'),(7,7,'Assistant'),(8,null,'Secretary');
insert into tree3 select a.id,a.mgrid,a.name,a.birthyear,b.gubun from tree a, (select rownum gubun from dual connect by level <= 6000) b;
update statistics on tree,tree2,tree3;
SELECT /*+ recompile */ count(*) FROM tree3 t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null and gubun = 1 CONNECT BY prior t.id=t.mgrid and gubun = 1;
show trace;

--sql hint
drop table if exists tree3; 
CREATE TABLE tree3(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT,gubun int);
insert into tree3 select a.id,a.mgrid,a.name,a.birthyear,b.gubun from tree a, (select rownum gubun from dual connect by level <= 5000) b;
SELECT /*+ recompile */ count(*) FROM tree3 t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null and gubun = 1 CONNECT BY prior t.id=t.mgrid and gubun = 1;
show trace;
SELECT /*+ NO_HASH_LIST_SCAN */ count(*) FROM tree3 t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null and gubun = 1 CONNECT BY prior t.id=t.mgrid and gubun = 1;
show trace;

--performance test
drop table if exists tree3; 
CREATE TABLE tree3(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT,gubun int);
insert into tree3 select a.id,a.mgrid,a.name,a.birthyear,b.gubun from tree a, (select rownum gubun from dual connect by level <= 1000) b;
SELECT /*+ recompile */ count(*) FROM tree3 t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id=t.mgrid and gubun = 1;
show trace;
SELECT /*+ NO_HASH_LIST_SCAN */ count(*) FROM tree3 t INNER JOIN tree2 t2 ON t.id=t2.treeid START WITH t.mgrid is null CONNECT BY prior t.id=t.mgrid and gubun = 1;
show trace;

drop tree;
drop tree2;
drop tree3;
