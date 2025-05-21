set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop table if exists pay,costs,test;
create class test (id int PRIMARY KEY, a int);
create class costs as subclass of test (costs int );
create class pay as subclass of costs (pay int );

insert into test values (97,1);
insert into test values (98,1);
insert into test values (99,1);

insert into costs values (153,1,100);
insert into costs values (154,1,100);


insert into pay values (155,1,NULL,6000);
insert into pay values (156,1,100,6001);

select * from pay order by 1,2,3;


select ifnull(costs,100) as bxx from pay group by costs order by 1;
select ifnull(costs,100) as bxx from pay group by bxx order by 1;
select ifnull(costs,100) as costs from pay group by costs order by 1;

alter table test
    drop column a;


select ifnull(costs,100) as bxx from pay group by costs order by 1;
select ifnull(costs,100) as bxx from pay group by bxx order by 1;
select ifnull(costs,100) as costs from pay group by costs order by 1;

drop table if exists pay,costs,test;
---------------------------------------------------

drop table if exists test;
CREATE table test(x varchar(2));
insert into test values('aa');
SELECT t.* FROM test AS t order by 1;
drop table if exists test;
---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1( `position` INT); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES(2); 
INSERT INTO t1 VALUES(3); 
select `position`, count(*) as c from t1 group by `position` desc order by c order by 1;
select `position`, count(*) as c from t1 group by `position` asc order by c order by 1;
drop table if exists t1;

---------------------------------------------------
drop table if exists t1;
CREATE TABLE t1( b INT); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES(2); 

select ifnull(t1.`b`,2) as bxx from dba.`t1` group by b order by 1;
select ifnull(t1.`b`,3) as bxx from dba.`t1` group by b order by 1;
select ifnull(t1.`b`,3) as `bxx` from dba.`t1` group by b order by 1;
select ifnull(t1.`b`,3) as `bxx` from dba.`t1` group by `b` order by 1;

select ifnull(t1.`b`,2) as bxx from dba.`t1` group by bxx order by 1;
select ifnull(t1.`b`,3) as bxx from dba.`t1` group by bxx order by 1;
select ifnull(t1.`b`,3) as `bxx` from dba.`t1` group by bxx order by 1;
select ifnull(t1.`b`,3) as `bxx` from dba.`t1` group by `bxx` order by 1;

select t1.`b` as bxx from dba.`t1` group by bxx order by 1;
drop table if exists t1;
---------------------------------------------------
drop table if exists t1;
CREATE TABLE t1( b varchar(10)); 
INSERT INTO t1 VALUES('aaa'); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES('aaaa'); 


select cast(ifnull(b,'aaa') as varchar(20)) as bxx from t1 a group by bxx order by 1;

select cast(ifnull(b,'aaa') as varchar(20)) as bxx from t1 a group by b order by 1;

select cast(ifnull(b,'aaa') as varchar(20)) as b from t1 a group by b order by 1;


select cast(ifnull(b,'aaa') as varchar(2)) as bxx from t1 a group by bxx order by 1;

select cast(ifnull(b,'aaa') as varchar(2)) as bxx from t1 a group by b order by 1;

select cast(ifnull(b,'aaa') as varchar(2)) as b from t1 a group by b order by 1;

drop table if exists t1;
---------------------------------------------------
drop table if exists bug6157;
drop view x;
create table bug6157(x int, VCField VARCHAR(30) DEFAULT NULL, DtField DATE);
INSERT INTO bug6157 VALUES (1, 'TEST', '2007-09-10');
create view x as SELECT x, VCField AS Fld2, DtField AS Fld3 FROM bug6157;
UPDATE x SET `Fld2`='testing' WHERE `x`=1 AND `Fld2`='TEST';
select * from x order by 1,2,3;

drop table if exists bug6157;
drop view x;
---------------------------------------------------


DROP TABLE IF EXISTS t1, t2, t3, t4, t5, t6;
CREATE TABLE t1 (a INT);
CREATE TABLE t2 (a INT);
CREATE TABLE t3 (a INT, INdex T3_A (a));
CREATE TABLE t4 (a INT);
CREATE TABLE t5 (a INT);
CREATE TABLE t6 (a INT);

INSERT INTO t1 VALUES (1), (1), (1);

INSERT INTO t2 VALUES
(2), (2), (2), (2), (2), (2), (2), (2), (2), (2),
(2), (2), (2), (2), (2),(0),(1);

INSERT INTO t3 VALUES
(3), (3), (3), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3), (1);

SELECT *
FROM
  t1 LEFT OUTER JOIN t2 ON t1.a = t2.a
     LEFT OUTER JOIN t3 ON t1.a = t3.a
WHERE t2.a=1 order by 1;

DROP TABLE IF EXISTS t1, t2, t3, t4, t5, t6;

---------------------------------------------------

DROP TABLE IF EXISTS `features_test`,`idList`;
CREATE TABLE  `features_test` (
  `param` int(11) NOT NULL,
  `idx` int(11) NOT NULL,
  `text` varchar(255) default NULL,
  PRIMARY KEY  (`param`,`idx`)
);

INSERT INTO `features_test` (`param`, `idx`, `text`) VALUES
(1, 0, 'select'),
(1, 1, 'Kabel mit Stecker 5-polig'),
(1, 2, 'Kabel ohne Stecker'),
(2, 0, 'number'),
(2, 1, '22'),
(2, 2, '25');

CREATE TABLE `idList` (
  `id` int PRIMARY KEY
);

INSERT INTO idList VALUES (1),(2),(3),(4);

SELECT idList.id AS id, T.text AS xtext,GROUP_CONCAT(T3.text) AS optionen
FROM idList
LEFT JOIN features_test AS T  ON(T.param=idList.id AND T.idx=0 )
LEFT JOIN features_test AS T3 ON(T3.param=idList.id AND T3.idx>0 ) 
GROUP BY idList.id
ORDER BY id ASC order by 1,2,3;

SELECT idList.id AS id, T.text AS xtext,GROUP_CONCAT(T3.text) AS optionen
FROM idList
LEFT JOIN features_test AS T  ON(T.param=idList.id AND T.idx=0 )
LEFT JOIN features_test AS T3 ON(T3.param=idList.id AND T3.idx>0 ) 
GROUP BY idList.id
ORDER BY id DESC order by 1,2,3;

DROP TABLE IF EXISTS `features_test`,`idList`;
---------------------------------------------------

DROP TABLE IF EXISTS orderbycrash;
CREATE TABLE orderbycrash (Value1 int NOT NULL default '0');
SELECT t1.Value1 as aa, t2.Value1 AS bb  FROM orderbycrash t1, orderbycrash t2 ORDER BY  aa > 1 order by 1,2;
DROP TABLE IF EXISTS orderbycrash;

---------------------------------------------------

drop table if exists bug6157;
drop view x;
drop view x1;
create table bug6157(x int, VCField VARCHAR(30) DEFAULT NULL, DtField DATE);
INSERT INTO bug6157 VALUES (1, 'TEST', '2007-09-10');
create view x as SELECT x, ifnull(VCField,'aa') AS Fld2, DtField AS Fld3 FROM bug6157 ;
UPDATE x1 SET `Fld2`='testing' WHERE `x`=1 AND `Fld2`='aa';
select * from x1 order by 1,2,3;

drop table if exists bug6157;
drop view x;
drop view x1;
---------------------------------------------------

drop table if exists emp;
CREATE TABLE emp(id int, name varchar(10), sal decimal(7,2), deptno int);
insert into emp values(1000, 'JONES', 3500.00, 10);
insert into emp values(2000, 'CLARK', 1500.00, 20);
insert into emp values(3000, 'KING',  5000.00, 10);
insert into emp values(4000, 'SMITH', 2000.00, 10);
insert into emp values(5000, 'WARD',  2500.00, 30);
insert into emp values(6000, 'BLAKE', 3000.00, 30);
insert into emp values(7000, 'FORD',  4000.00, 20);

SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno order by 1,2;
drop table if exists emp;

---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1( b INT); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES(2); 
INSERT INTO t1 VALUES(2); 

select cast(ifnull(b,'aaa') as varchar(20)) as bxx from t1 a where cast(ifnull(b,'aaa') as varchar(20))='aaa' group by bxx order by 1;

select cast(ifnull(b,'aaa') as varchar(20)) as bxx from t1 a group by bxx order by 1;

select cast(ifnull(b,'aaa') as varchar(20)) as bxx from t1 a group by b order by 1;

select cast(ifnull(b,2) as varchar(20)) as bxx from t1 a group by bxx order by 1;

select cast(ifnull(b,2) as varchar(20)) as bxx from t1 a group by b order by 1;

select cast(b as varchar(20)) as bxx from t1 a group by bxx order by 1;

select cast(b as varchar(20)) as bxx from t1 a group by b order by 1;

select cast(b as varchar(20))  from t1 a group by b order by 1;

drop table if exists t1;
drop table if exists test;
---------------------------------------------------
drop table if exists t1;
CREATE TABLE t1( b INT); 
INSERT INTO t1 VALUES(1); 
INSERT INTO t1 VALUES(NULL); 
INSERT INTO t1 VALUES(2); 

select ifnull(b,2) as bxx from t1 a group by bxx order by 1;

select ifnull(b,2) as b from t1 a group by b order by 1;


select distinct (b)  from t1 group by b order by 1;
select distinct (ifnull(b,3)) as bxx from t1 group by b order by 1;

select distinct (ifnull(b,1)) as b from t1 group by b order by 1;
select distinct (ifnull(b,1)) as bxx from t1 group by bxx order by 1;

select distinct (b) as bxx from t1 group by b order by 1;
select distinct (b) as b from t1 group by b order by 1;
select distinct (b) as bxx from t1 group by bxx order by 1;

select a as aa from t1 a group by aa order by 1;
drop table if exists t1;
---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 

prepare st from 'SELECT a, ifnull(b,?) AS bxx FROM t1 GROUP BY a, bxx order by 1,2;';
execute st using 2;
deallocate prepare st;

prepare st from 'SELECT a, ifnull(b,?) AS bxx FROM t1 GROUP BY a, b order by 1,2;';
execute st using 2;
deallocate prepare st;

prepare st from 'SELECT a, ifnull(b,?) FROM t1 GROUP BY a, b order by 1,2;';
execute st using 2;
deallocate prepare st;
drop table if exists t1;
---------------------------------------------------
drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 


SELECT a, ifnull(t.b,2) AS bxx 
        FROM t1 t
        GROUP BY a, t.bxx order by 1,2;

SELECT a, ifnull(t.b,2) AS bxx 
        FROM t1 t
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(t.b,2) AS bxx 
        FROM t1 t
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(t.b,2) AS bxx 
        FROM t1 t
        GROUP BY a, t.bxx order by 1,2;

SELECT a, ifnull(t.b,2) AS bxx 
        FROM t1 t
        GROUP BY a, t1.bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by 1,2;

drop table if exists t1;
---------------------------------------------------
drop table if exists `test`;
CREATE TABLE `test` (
  `col1` int  NOT NULL AUTO_INCREMENT,
  `col2` int NOT NULL DEFAULT '0',
  `col3` int NOT NULL DEFAULT '0',
  `col4` int NOT NULL DEFAULT '0',
  `col5` int NOT NULL DEFAULT '0',
  `col6` varchar(100) NOT NULL DEFAULT '',
  `col7` char(50) NOT NULL DEFAULT '',
  `col8` int(6) NOT NULL DEFAULT '0',
  `col9` int(6) NOT NULL DEFAULT '1',
  `col10` varchar(100) NOT NULL DEFAULT '',
  `col11` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`col1`),
  UNIQUE KEY `col10` (`col10`),
  KEY `col2` (`col2`),
  KEY `col11` (`col11`),
  KEY `col9` (`col9`)
) ;

insert into test values(null,default,default,default,default,default,default,default,default,default,default);
SELECT t.* FROM test AS t order by 1,2,3,4,5,6,7;
drop table if exists `test`;
---------------------------------------------------
drop table if exists `t1`;
CREATE TABLE `t1` (
  `col1` int NOT NULL default '0',
  `col2` int NOT NULL default '0'
);

INSERT INTO `t1` VALUES (1, 1);
INSERT INTO `t1` VALUES (2, 2);

select col1, col2 from `t1` group by col1, col2 having col1 != 1 and col1 > 1 order by 1,2;

SELECT 0 AS x, col1 AS y
FROM `t1` 
GROUP BY col1, col2
HAVING y >0
AND x =1 order by 1,2;

drop table if exists `t1`;
---------------------------------------------------
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (i INT, j INT);

 INSERT INTO t1 VALUES(1,1);
 INSERT INTO t1 VALUES(1,2);
 INSERT INTO t1 VALUES(1,3);
 INSERT INTO t1 VALUES(2,1);
 INSERT INTO t1 VALUES(2,2);
 INSERT INTO t1 VALUES(2,3);
 INSERT INTO t1 VALUES(3,3);
 INSERT INTO t1 VALUES(3,2);
 INSERT INTO t1 VALUES(3,1);

 SELECT i, 0 AS j, COUNT(*) FROM t1 GROUP BY i, j order by 1,2;

 SELECT i, 0 AS x, COUNT(*) FROM t1 GROUP BY i, x order by 1,2;
DROP TABLE IF EXISTS t1;

--+ holdcas off;
commit;
set system parameters 'create_table_reuseoid=yes';
