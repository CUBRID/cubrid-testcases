
--03_natural_join_bug_from_web_009.sql
drop table if exists a;
drop table if exists b;
drop table if exists c;
create table a ( id nchar(10)); 
create table b ( id nchar(20));
create table c ( id nchar(20));
insert into a values(n'aaa');
insert into a values(n'bbb');
insert into b values(n'aaa');
insert into b values(n'ddd');
insert into c values(n'aaa');
insert into c values(n'dddd');

select * from a
   where id in (select id from b where id in (select id from c));

select * from a 
   where id in (select id from b where id in (select id from c where id in (select id from a)));

select * from a 
   where id in (select id from b where id in (select id from c where id in (select id from a where id in (select id from b where id in (select id from c where id in (select id from a))))));

drop table if exists a;
drop table if exists b;
drop table if exists c;

drop table if exists masterTABLE,childTABLE1,childTABLE2;

 CREATE TABLE masterTABLE (
  pid int(11) NOT NULL default '0',
  c1id int(11) default NULL,
  c2id int(11) default NULL,
  `value` int(11) NOT NULL default '0',
  UNIQUE KEY pid2 (pid,c1id,c2id),
  UNIQUE KEY pid (pid,`value`)
) ;

INSERT INTO masterTABLE VALUES (1, 1, NULL, 1);
INSERT INTO masterTABLE VALUES (1, 2, NULL, 2);
INSERT INTO masterTABLE VALUES (1, NULL, 3, 3);
INSERT INTO masterTABLE VALUES (1, 4, NULL, 4);
INSERT INTO masterTABLE VALUES (1, 5, NULL, 5);

CREATE TABLE childTABLE1 (
  id int(11) NOT NULL default '0',
  active enum('Yes','No') NOT NULL default 'Yes',
  PRIMARY KEY  (id)
) ;


INSERT INTO childTABLE1 VALUES (1, 'Yes');
INSERT INTO childTABLE1 VALUES (2, 'No');
INSERT INTO childTABLE1 VALUES (4, 'Yes');
INSERT INTO childTABLE1 VALUES (5, 'No');

CREATE TABLE childTABLE2 (
  id int(11) NOT NULL default '0',
  active enum('Yes','No') NOT NULL default 'Yes',
  PRIMARY KEY  (id)
) ;

INSERT INTO childTABLE2 VALUES (3, 'Yes');


SELECT MAX( `value` ) 
FROM masterTABLE AS m 
NATURAL LEFT JOIN childTABLE1 AS c1
NATURAL LEFT JOIN childTABLE2 AS c2
WHERE m.pid=1
AND c1.id IS NOT NULL OR c2.id IS NOT NULL OR c1.active = 'Yes' OR c2.active = 'Yes';

drop table if exists masterTABLE,childTABLE1,childTABLE2;
-----------------------------------------------------------------------------

DROP TABLE IF EXISTS t1, t2, t3, t4, t5, t6;
CREATE TABLE t1 (a INT);
CREATE TABLE t2 (a INT);
CREATE TABLE t3 (a INT,index t3_a (a));
CREATE TABLE t4 (a INT);
CREATE TABLE t5 (a INT);
CREATE TABLE t6 (a INT);

INSERT INTO t1 VALUES (1), (1), (1),(2), (2), (2), (2), (2), (2), (2), (2), (2), (2),
(2), (2), (2), (2), (2),(3), (3);

INSERT INTO t2 VALUES
(2), (2), (2), (2), (2), (2), (2), (2), (2), (2),
(2), (2), (2), (2), (2),(3), (3);

INSERT INTO t3 VALUES
(3), (3), (3), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3),(2), (2),(1), (1);

INSERT INTO t4 VALUES
(4), (4), (4), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3),(2), (2),(1), (1);

INSERT INTO t5 VALUES
(5), (5), (5), (4), (4), (4), (3), (3), (3), (3),
(3), (3), (3), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3),(2), (2),(1), (1);

INSERT INTO t6 VALUES
(4), (4), (4), (5), (6), (4), (3), (3), (3), (3),
(3), (3), (3), (3), (3), (3), (3), (3), (3), (3),
(3), (3), (3),(2), (2),(1), (1);

SELECT *
FROM
  t1 LEFT OUTER join (select * from t2 order by 1) t2 ON t1.a = t2.a
     LEFT OUTER join (select * from t3 order by 1) t3 ON t1.a = t3.a
        LEFT OUTER JOIN t4 ON t3.a = t4.a
        LEFT OUTER JOIN t5 ON t4.a = t5.a
        LEFT OUTER JOIN t6 ON t5.a = t6.a    
WHERE t2.a=2;

SELECT *
FROM
  t1 NATURAL LEFT OUTER join (select * from t2 order by 1) t2
     NATURAL LEFT OUTER join (select * from t3 order by 1) t3
        NATURAL LEFT OUTER JOIN t4
        NATURAL LEFT OUTER JOIN t5
        NATURAL LEFT OUTER JOIN t6    
WHERE t2.a=2;

SELECT *
FROM
  t1 NATURAL LEFT OUTER join (select * from t2 order by 1) t2
     NATURAL LEFT OUTER join (select * from t3 order by 1) t3
        NATURAL RIGHT OUTER JOIN t4
        NATURAL LEFT OUTER JOIN t5
        NATURAL RIGHT OUTER JOIN t6    
WHERE t2.a=2;

DROP TABLE IF EXISTS t1, t2, t3, t4, t5, t6;

-----------
drop table if exists test;
create table test (id int primary key, name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
select * from test order by 1,2;

--Positive
delete test from test inner join (values(1),(2)) as t(id) on [test].id=t.id;
select * from test order by 1,2;

delete from test;
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test natural join (values(1),(2)) as t(id);
select * from test order by 1,2;

select * from test natural join (values(1),(2)) as t(id) order by 1,2;
delete test from test natural join (values(1),(2)) as t(id);
select * from test order by 1,2;

delete from test;
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test inner join (values(1),(2)) as t(id) on test.id=t.id;
select * from test order by 1,2;


--bug
drop table if exists test;
create table test (id int primary key, name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
select * from test order by 1,2;
select * from test natural join (values(1),(2)) as t(id);
delete test from test natural join (values(1),(2)) as t(id);
select * from test order by 1,2;


drop table if exists test;
create table test (id int primary key, name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test inner join (values(1),(2)) as t(id) on test.id=t.id;
select * from test order by 1,2;
delete from test;

insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test natural join (values(1),(2)) as t(id);
select * from test order by 1,2;

drop table if exists test;
create table test (id int primary key, name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
select * from test inner join (values(1),(2)) as t(id) on 1<>0 order by 1,2;

select * from test inner join (values(1),(2)) as t(id) on t.id=test.id order by 1,2;


update test set id=5 where id =1 union (1 inner join (values(1),(2)) as t(id));
update test set id=5 where id =1 join (values(1),(2)) as t(id);
update test set id=5 where id =1 natural join (values(1),(2)) as t(id);



drop table if exists test;
create table test (id int primary key, name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test left join (values(1),(2)) as t(id) on test.id=t.id;
select * from test order by 1,2;
delete from test;



drop table if exists test;
create table test (id int primary key, name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test right join (values(1),(2)) as t(id) on test.id=t.id;
select * from test order by 1,2;
delete from test;


drop table if exists test;
create table test (id int primary key, name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete test from test cross join (values(1),(2)) as t(id) ;
select * from test order by 1,2;
delete from test;


drop table if exists test;
create table test (id int , name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
update test inner join (values(1),(2)) as t(id) on test.id=t.id set test.id=5 ;
select * from test order by 1,2;
delete from test;


--good result
update test inner join (values(1),(2)) as t(id) test.id=t.id set test.id=5 ;
select * from test order by 1,2;
delete from test;



drop table if exists test;
create table test (id int , name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');

--good result
update test inner join (values(1),(2)) as t(id) on test.id=t.id set test.id=5 ;
select * from test order by 1,2;
delete from test;

insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
--error result
update test natural join (values(1),(2)) as t(id) set test.id=5 ;
select * from test order by 1,2;
delete from test;

drop table if exists test;



--------------------------------------------------------
DROP TABLE /*! IF EXISTS */ t1;
DROP TABLE /*! IF EXISTS */ t2;

CREATE TABLE t1 (  
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `col_int_key` int(11) DEFAULT NULL,  
  `col_varchar_key` varchar(1) DEFAULT NULL,  
  `col_varchar_nokey` varchar(1) DEFAULT NULL,  
  PRIMARY KEY (`pk`),  
  KEY `col_int_key` (`col_int_key`),  
  KEY `col_varchar_key` (`col_varchar_key`,`col_int_key`)) 
;

INSERT INTO t1 VALUES (29,4,'c','c');

CREATE TABLE t2 (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `col_int_key` int(11) DEFAULT NULL,
  `col_varchar_key` varchar(1) DEFAULT NULL,
  `col_varchar_nokey` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  KEY `col_int_key` (`col_int_key`),
  KEY `col_varchar_key` (`col_varchar_key`,`col_int_key`))
;

INSERT INTO t2 VALUES (4,9,'k','k');
INSERT INTO t2 VALUES (5,NULL,'r','r');
INSERT INTO t2 VALUES (6,9,'t','t');
INSERT INTO t2 VALUES (7,3,'j','j');
INSERT INTO t2 VALUES (8,8,'u','u');
INSERT INTO t2 VALUES (9,8,'h','h');
INSERT INTO t2 VALUES (10,53,'o','o');
INSERT INTO t2 VALUES (11,0,NULL,NULL);
INSERT INTO t2 VALUES (12,5,'k','k');
INSERT INTO t2 VALUES (13,166,'e','e');
INSERT INTO t2 VALUES (14,3,'n','n');
INSERT INTO t2 VALUES (15,0,'t','t');
INSERT INTO t2 VALUES (16,1,'c','c');
INSERT INTO t2 VALUES (17,9,'m','m');
INSERT INTO t2 VALUES (18,5,'y','y');

SELECT t1 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  JOIN (( select table2.`pk`,table2.`col_int_key`,table2.`col_varchar_key` from t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`<>0 )t )  WHERE t .`col_int_key`  >= t1 .`pk`  
  AND t .`col_varchar_key`  > t1 .`col_varchar_nokey`   
 order by 1;

select table2.`pk`,table2.`col_int_key`,table2.`col_varchar_key` from t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`<>0 order by 1,2,3;

SELECT t1 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  JOIN (( select table2.`pk`,table2.`col_int_key`,table2.`col_varchar_key` from t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`<>0 )t )  ON t .`col_int_key`  >= t1 .`pk`  
  AND t .`col_varchar_key`  < t1 .`col_varchar_nokey`   
 order by 1;

SELECT t1 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  JOIN (( select table2.`pk`,table2.`col_int_key`,table2.`col_varchar_key` from t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`<>0 )t )  ON t .`col_int_key`  >= t1 .`pk`  
  AND t .`col_varchar_key`  = t1 .`col_varchar_nokey`   
 order by 1;

SELECT t1 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  JOIN (( select table2.`pk`,table2.`col_int_key`,table2.`col_varchar_key` from t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`<>0 )t )  ON t .`col_int_key`  >= t1 .`pk`  
  AND t .`col_varchar_key`  > t1 .`col_varchar_nokey`   
 order by 1;

SELECT table2 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  JOIN ( t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`<>0  )  ON table3 .`col_int_key`<>0  >= table2 .`pk`  
  AND table3 .`col_varchar_key`  = table2 .`col_varchar_nokey`   
 order by 1;

SELECT table2 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  JOIN ( t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`  )  where table3 .`col_int_key`  >= table2 .`pk`  
  AND table3 .`col_varchar_key`  = table2 .`col_varchar_nokey`   
 order by 1;


SELECT table2 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  join (select * from t2 order by 1,2) t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk`  order by 1;

SELECT table2 .`col_int_key`  
from (select * from t1 order by 1,2) t1  
  join (select * from t2 order by 1,2) t2 table2  join (select * from t2 order by 1,2) table3  ON table3 .`pk` where table3 .`col_int_key`  >= table2 .`pk`  
  AND table3 .`col_varchar_key`  = table2 .`col_varchar_nokey` order by 1;


SELECT table2 .`col_int_key`
from (select * from t1 order by 1,2) t1  
  join (select * from t2 order by 1,2) t2 table2  join (select * from t2 order by 1,2) table3 where table3 .`col_int_key`  >= table2 .`pk`  
  AND table3 .`col_varchar_key`  = table2 .`col_varchar_nokey` order by 1;

DROP TABLE /*! IF EXISTS */ t1;
DROP TABLE /*! IF EXISTS */ t2;
