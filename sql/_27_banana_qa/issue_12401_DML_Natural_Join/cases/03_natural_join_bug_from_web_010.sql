--03_natural_join_bug_from_web_010.sql
--disable_warnings
DROP TABLE /*! IF EXISTS */ CC;
DROP TABLE /*! IF EXISTS */ C;
DROP TABLE /*! IF EXISTS */ B;
--enable_warnings

CREATE TABLE `CC` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `col_int_nokey` int(11) DEFAULT NULL,
  `col_int_key` int(11) DEFAULT NULL,
  `col_datetime_key` datetime DEFAULT NULL,
  `col_varchar_key` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  KEY `col_int_key` (`col_int_key`),
  KEY `col_datetime_key` (`col_datetime_key`),
  KEY `col_varchar_key` (`col_varchar_key`,`col_int_key`)
) AUTO_INCREMENT=30 ;
INSERT INTO `CC` VALUES (10,7,8,'2002-02-26 06:14:37','v');
INSERT INTO `CC` VALUES (11,1,9,'1900-01-01 00:00:00','r');
INSERT INTO `CC` VALUES (12,5,9,'2006-12-03 09:37:26','a');
INSERT INTO `CC` VALUES (13,3,186,'2008-05-26 12:27:10','m');
INSERT INTO `CC` VALUES (14,6,NULL,'2004-12-14 16:37:30','y');
INSERT INTO `CC` VALUES (15,92,2,'2003-02-11 21:19:41','j');
INSERT INTO `CC` VALUES (16,7,3,'2009-10-18 02:27:49','d');
INSERT INTO `CC` VALUES (17,NULL,0,'2000-09-26 07:45:57','z');
INSERT INTO `CC` VALUES (18,3,133,NULL,'e');
INSERT INTO `CC` VALUES (19,5,1,'2005-11-10 12:40:29','h');
INSERT INTO `CC` VALUES (20,1,8,'2009-04-25 00:00:00','b');
INSERT INTO `CC` VALUES (21,2,5,'2002-11-27 00:00:00','s');
INSERT INTO `CC` VALUES (22,NULL,5,'2004-01-26 20:32:32','e');
INSERT INTO `CC` VALUES (23,1,8,'2007-10-26 11:41:40','j');
INSERT INTO `CC` VALUES (24,0,6,'2005-10-07 00:00:00','e');
INSERT INTO `CC` VALUES (25,210,51,'2000-07-15 05:00:34','f');
INSERT INTO `CC` VALUES (26,8,4,'2000-04-03 16:33:32','v');
INSERT INTO `CC` VALUES (27,7,7,NULL,'x');
INSERT INTO `CC` VALUES (28,5,6,'2001-04-25 01:26:12','m');
INSERT INTO `CC` VALUES (29,NULL,4,'2000-12-27 00:00:00','c');
CREATE TABLE `C` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `col_int_nokey` int(11) DEFAULT NULL,
  `col_int_key` int(11) DEFAULT NULL,
  `col_datetime_key` datetime DEFAULT NULL,
  `col_varchar_key` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  KEY `col_int_key` (`col_int_key`),
  KEY `col_datetime_key` (`col_datetime_key`),
  KEY `col_varchar_key` (`col_varchar_key`,`col_int_key`)
) AUTO_INCREMENT=21;
INSERT INTO `C` VALUES (1,NULL,2,'2004-10-11 18:13:16','w');
INSERT INTO `C` VALUES (2,7,9,NULL,'m');
INSERT INTO `C` VALUES (3,9,3,'1900-01-01 00:00:00','m');
INSERT INTO `C` VALUES (4,7,9,'2009-07-25 00:00:00','k');
INSERT INTO `C` VALUES (5,4,NULL,NULL,'r');
INSERT INTO `C` VALUES (6,2,9,'2008-07-27 00:00:00','t');
INSERT INTO `C` VALUES (7,6,3,'2002-11-13 16:37:31','j');
INSERT INTO `C` VALUES (8,8,8,'1900-01-01 00:00:00','u');
INSERT INTO `C` VALUES (9,NULL,8,'2003-12-10 00:00:00','h');
INSERT INTO `C` VALUES (10,5,53,'2001-12-21 22:38:22','o');
INSERT INTO `C` VALUES (11,NULL,0,'2008-12-13 23:16:44',NULL);
INSERT INTO `C` VALUES (12,6,5,'2005-08-15 12:39:41','k');
INSERT INTO `C` VALUES (13,188,166,NULL,'e');
INSERT INTO `C` VALUES (14,2,3,'2006-09-11 12:06:14','n');
INSERT INTO `C` VALUES (15,1,0,'2007-12-15 12:39:34','t');
INSERT INTO `C` VALUES (16,1,1,'2005-08-09 00:00:00','c');
INSERT INTO `C` VALUES (17,0,9,'2001-09-02 22:50:02','m');
INSERT INTO `C` VALUES (18,9,5,'2005-12-16 22:58:11','y');
INSERT INTO `C` VALUES (19,NULL,6,'2007-04-19 00:19:53','f');
INSERT INTO `C` VALUES (20,4,2,'1900-01-01 00:00:00','d');
CREATE TABLE `B` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `col_int_nokey` int(11) DEFAULT NULL,
  `col_int_key` int(11) DEFAULT NULL,
  `col_datetime_key` datetime DEFAULT NULL,
  `col_varchar_key` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  KEY `col_int_key` (`col_int_key`),
  KEY `col_datetime_key` (`col_datetime_key`),
  KEY `col_varchar_key` (`col_varchar_key`,`col_int_key`)
) AUTO_INCREMENT=2;
INSERT INTO `B` VALUES (1,1,7,'2005-02-05 00:00:00','f');



SELECT    MIN(  table1 . `col_int_key` ) AS field1 
FROM ( CC AS table1 RIGHT JOIN C AS table2 ON (table2 . `col_int_key` = table1 . `col_int_nokey`  ) ) ;



SELECT    MIN(  table1 . `col_int_key` ) AS field1 
FROM  CC AS table1 RIGHT JOIN C AS table2 ON (table2 . `col_int_key` = table1 . `col_int_nokey`  )  
WHERE (  ( 'k', 'c' )  IN ( 
SELECT 'e' , 'l' UNION  
SELECT 'j' , 't' ) ) OR ( table1 . `col_int_key` = table1 . `col_int_key` AND table1 . `pk` = 232 ) OR (  table1 . `col_varchar_key`  IN ( 
SELECT   SUBQUERY2_t2 . `col_varchar_key` AS SUBQUERY2_field1 
FROM ( B AS SUBQUERY2_t1 LEFT  JOIN B AS SUBQUERY2_t2 ON (SUBQUERY2_t2 . `pk` = SUBQUERY2_t1 . `col_int_key`  ) ) 
WHERE SUBQUERY2_t1 . `col_varchar_key` <> table1 . `col_varchar_key` AND SUBQUERY2_t1 . `col_varchar_key` < table2 . `col_varchar_key` ) OR table1 . `col_int_key` >= table2 . `col_int_key` )  
HAVING  ( 7, 7 )  IN ( 
SELECT DISTINCT SQL_SMALL_RESULT , SUBQUERY3_t1 . `col_int_nokey` AS SUBQUERY3_field1 , SUBQUERY3_t1 . `col_int_nokey` AS SUBQUERY3_field2 
FROM C AS SUBQUERY3_t1 
WHERE SUBQUERY3_t1 . `col_varchar_key` < 'y'   ) 
ORDER BY table1 . `col_datetime_key`  , field1 
LIMIT 2
;


DROP TABLE CC;
DROP TABLE C;
DROP TABLE B;
----------------

drop table t1;
drop table where_subselect;
CREATE TABLE t1 (
  pk INT NOT NULL ,
  col_int_key INT DEFAULT NULL,
  col_varchar_key VARCHAR(1) DEFAULT NULL,
  PRIMARY KEY (pk)
);
INSERT INTO t1 VALUES (27,7,'x');
INSERT INTO t1 VALUES (28,6,'m');
INSERT INTO t1 VALUES (29,4,'c');

CREATE TABLE where_subselect as (
  SELECT DISTINCT pk AS field1 , pk AS field2 
  from (select * from t1 order by 1,2) t1
  )
;


SELECT * 
FROM where_subselect 
WHERE (field1, field2) IN (  
  SELECT pk AS field1 , pk AS field2  from (select * from t1 order by 1,2) alias1 WHERE alias1 . `col_int_key` > 4 
  GROUP BY field1, field2
);



SELECT * 
FROM where_subselect 
WHERE (field1, field2) IN (  
  SELECT {pk , pk }   from (select * from t1 order by 1,2) alias1 WHERE alias1 . `col_int_key` > 4
  GROUP BY pk
) order by 1;


drop table t1;
drop table where_subselect;
