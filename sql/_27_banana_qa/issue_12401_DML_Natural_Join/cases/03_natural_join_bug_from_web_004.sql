drop table if exists t1;
CREATE TABLE t1 (pk INT PRIMARY KEY, int_key INT, varchar_key VARCHAR(5));
INSERT INTO t1 VALUES (9, 7,NULL);
INSERT INTO t1 VALUES (10,8,'p');

-- let's compare results with inner and left join
SELECT INNR.pk FROM t1 AS INNR2 JOIN t1 AS INNR ON (INNR2.int_key = INNR.int_key) WHERE INNR.varchar_key > 'n{' order by 1;
SELECT INNR.pk FROM t1 AS INNR2 LEFT JOIN t1 AS INNR ON (INNR2.int_key = INNR.int_key) WHERE INNR.varchar_key > 'n{' order by 1;

SELECT INNR.pk FROM t1 AS INNR2 NATURAL JOIN t1 AS INNR WHERE INNR.varchar_key > 'n{' order by 1;
SELECT INNR.pk FROM t1 AS INNR2 NATURAL LEFT JOIN t1 AS INNR WHERE INNR.varchar_key > 'n{' order by 1;
SELECT INNR.pk FROM t1 AS INNR2 NATURAL RIGHT JOIN t1 AS INNR WHERE INNR.varchar_key > 'n{' order by 1;


SELECT * FROM t1 WHERE NULL NOT IN (
SELECT INNR.pk FROM t1 AS INNR2 JOIN t1 AS INNR ON (INNR2.int_key = INNR.int_key)
WHERE INNR.varchar_key > 'n{') order by 1,2;

SELECT * FROM t1 WHERE NULL NOT IN (
SELECT INNR.pk FROM t1 AS INNR2 LEFT JOIN t1 AS INNR ON (INNR2.int_key = INNR.int_key)
WHERE INNR.varchar_key > 'n{') order by 1,2;


SELECT * FROM t1 WHERE NULL NOT IN (
SELECT INNR.pk FROM t1 AS INNR2 NATURAL JOIN t1 AS INNR 
WHERE INNR.varchar_key > 'n{') order by 1,2;

SELECT * FROM t1 WHERE NULL NOT IN (
SELECT INNR.pk FROM t1 AS INNR2 NATURAL LEFT JOIN t1 AS INNR 
WHERE INNR.varchar_key > 'n{') order by 1,2;

SELECT * FROM t1 WHERE NULL NOT IN (
SELECT INNR.pk FROM t1 AS INNR2 NATURAL RIGHT JOIN t1 AS INNR 
WHERE INNR.varchar_key > 'n{') order by 1,2;
drop table if exists t1;


--bug CUBRIDSUS-12863 CUBRIDSUS-12865
drop table if exists a,b,c;
CREATE TABLE `b` (
  `idb` int(10) NOT NULL auto_increment,
  `value` int(10) NOT NULL default '0',
  PRIMARY KEY  (`idb`)
) ;
INSERT INTO `b` (`idb`,`value`) VALUES (1,1),(2,2),(3,3);
CREATE TABLE `c` (
  `ida` int(10) NOT NULL default '0',
  `idb` int(10)  NOT NULL default '0'
) ;
INSERT INTO `c` (`ida`,`idb`) VALUES (1,1),(2,1),(3,1),(4,1),(5,2),(3,2),(1,2),(2,3),(4,3);
CREATE TABLE `a` (
  `ida` int(10)  NOT NULL auto_increment,
  `value` int(10) NOT NULL default '0',
  PRIMARY KEY  (`ida`)
) ;
INSERT INTO `a` (`ida`,`value`) VALUES (1,1),(2,2),(3,3),(4,4),(5,5);

select * from a natural join c natural join b order by 1,2,3,4,5;
select * from a natural join c natural join b order by 1,2,3,4,5;
select * from c natural join a natural join b order by 1,2,3,4,5;

select * from a join c join b on a.ida = c.ida and b.idb = c.idb where a.ida = 1 order by 1,2,3,4;

select * from a join (b,c ) on a.ida = c.ida and b.idb = c.idb where a.ida = 1 order by 1,2,3,4;

select * from a join b on b.idb = a.ida where a.ida = 1 order by 1,2,3,4;

select * from a join c using (ida) order by 1,2,3,4;

select * from a natural join c natural join b order by 1,2,3,4,5;
select * from a natural join c natural join b order by 1,2,3,4,5;
select * from c natural join a natural join b order by 1,2,3,4,5;
drop table if exists a,b,c;

----------------------------------------------

drop table a;
drop table b;
drop table c;
CREATE TABLE b (
  idb int NOT NULL,
  value1 int NOT NULL
) ;
INSERT INTO b (idb,value1) VALUES (1,1);
INSERT INTO b (idb,value1) VALUES (2,2);
INSERT INTO b (idb,value1) VALUES (3,3);
CREATE TABLE c (
  ida int NOT NULL,
  idb int  NOT NULL
) ;
INSERT INTO c (ida,idb) VALUES (1,1);
INSERT INTO c (ida,idb) VALUES (2,1);
INSERT INTO c (ida,idb) VALUES (3,1);
INSERT INTO c (ida,idb) VALUES (4,1);
INSERT INTO c (ida,idb) VALUES (5,2);
INSERT INTO c (ida,idb) VALUES (3,2);
INSERT INTO c (ida,idb) VALUES (1,2);
INSERT INTO c (ida,idb) VALUES (2,3);
INSERT INTO c (ida,idb) VALUES (4,3);

CREATE TABLE a (
  ida int  NOT NULL,
  value1 int NOT NULL
) ;
INSERT INTO a (ida,value1) VALUES (1,1);
INSERT INTO a (ida,value1) VALUES (2,2);
INSERT INTO a (ida,value1) VALUES (3,3);
INSERT INTO a (ida,value1) VALUES (4,4);
INSERT INTO a (ida,value1) VALUES (5,5);

--bug CUBRIDSUS-14289
select * from a,b natural join c where a.ida = 1 order by 1,2,3,4,5;
select * from a,b natural left join c where a.ida = 1 order by 1,2,3,4,5;
select * from a,b natural right join c where a.ida = 1 order by 1,2,3,4,5;


select * from a,b join c on b.idb = c.idb where a.ida = 1 order by 1,2,3,4,5;
select count(*) from a a1,a a2,a a3,b join c on b.idb = c.idb where a1.ida = 1;
select * from b join c on b.idb = c.idb ,a where a.ida = 1 order by 1,2,3,4,5;
select count(*) from b join c on b.idb = c.idb,a a1,a a2,a a3 where a1.ida = 1;


select * from a,b join c on b.idb = c.idb where a.ida = 1 order by 1,2,3,4,5;
select * from b join c on b.idb = c.idb ,a where a.ida = 1 order by 1,2,3,4,5;

select * from a,b natural join c where a.ida = 1 order by 1,2,3,4,5;
select * from a,b natural left join c where a.ida = 1 order by 1,2,3,4,5;
select * from a,b natural right join c where a.ida = 1 order by 1,2,3,4,5;

drop table a;
drop table b;
drop table c;
