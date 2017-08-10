--+ holdcas on;

DROP TABLE IF EXISTS `C`;
CREATE TABLE `C` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `int_nokey` int(11) NOT NULL,
  `int_key` int(11) NOT NULL,
  `date_key` date NOT NULL,
  `date_nokey` date NOT NULL,
  `time_key` time NOT NULL,
  `time_nokey` time NOT NULL,
  `datetime_key` datetime NOT NULL,
  `datetime_nokey` datetime NOT NULL,
  `varchar_key` varchar(5) DEFAULT NULL,
  `varchar_nokey` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`pk`),
  KEY `int_key` (`int_key`),
  KEY `date_key` (`date_key`),
  KEY `time_key` (`time_key`),
  KEY `datetime_key` (`datetime_key`),
  KEY `varchar_key` (`varchar_key`)
) ;

INSERT INTO `C` VALUES (1,5,5,'2009-10-16','2009-10-16','09:28:15','09:28:15','2007-09-14 05:34:08','2007-09-14 05:34:08','qk','qk'),
(2,6,6,'0000-00-00','0000-00-00','23:06:39','23:06:39','0000-00-00 00:00:00','0000-00-00 00:00:00','j','j'),
(3,10,10,'2000-12-18','2000-12-18','22:16:19','22:16:19','2006-11-04 15:42:50','2006-11-04 15:42:50','aew','aew'),
(4,0,0,'2001-09-18','2001-09-18','00:00:00','00:00:00','2004-03-23 13:23:35','2004-03-23 13:23:35',NULL,NULL),
(5,6,6,'2007-08-16','2007-08-16','22:13:38','22:13:38','2004-08-19 11:01:28','2004-08-19 11:01:28','qu','qu');

select pk from C WHERE `int_nokey` IS NULL OR  `varchar_key` > 'kr' group by pk order by 1,2;
select pk from C WHERE `int_nokey` IS NULL OR  `varchar_key` > 'kr' order by 1,2;
DROP TABLE IF EXISTS `C`;
---------------------------------------------------
DROP TABLE IF EXISTS `t1`;
CREATE TABLE t1 (n INT);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (null);
INSERT INTO t1 VALUES (2);
SELECT n+1 AS n FROM t1 GROUP BY n order by 1;
SELECT ifnull(n,1)+1 AS n ,count(*) FROM t1 GROUP BY n order by 1;
SELECT ifnull(n,1)+1 AS n1 ,count(*) FROM t1 GROUP BY n1 order by 1;
SELECT ifnull(n,1)+1 AS n1 ,count(*) FROM t1 GROUP BY n order by 1;
DROP TABLE IF EXISTS `t1`;
---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx=2
        GROUP BY a, bxx order by 1,2;
--
SELECT a, ifnull(b,2) AS b 
        FROM t1 
        GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 
        GROUP BY 1, 2 order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 
        GROUP BY 1, 2 order by 1,2;


SELECT a, ifnull(b,2) AS b 
        FROM t1 where b=2
        GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b is null
        GROUP BY a, b order by 1,2;

--
SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx=2
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,3) AS bxx 
        FROM t1 where b =2
        GROUP BY a, bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx is null
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(b,2)=2
        GROUP BY a, bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(bxx,2)=2
        GROUP BY a, bxx order by 1,2;

--
SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, b order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, b order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, b order by 1,2;

drop table if exists t1;
---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 
--
SELECT a, ifnull(b,2) AS b 
        FROM t1 
        GROUP BY a, b order by a,b order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b=2
        GROUP BY a, b order by a,b order by 1,2;

SELECT a, ifnull(b,2) AS b 
        FROM t1 where b is null
        GROUP BY a, b order by a,b order by 1,2;

--
SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by a,bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx=2
        GROUP BY a, bxx order by a,bxx order by 1,2;

SELECT a, ifnull(b,3) AS bxx 
        FROM t1 
        GROUP BY a, bxx having bxx<>3 order by 1,2;

SELECT a, ifnull(b,3) AS bxx 
        FROM t1 
        GROUP BY a, bxx having bxx=3 order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx order by a,bxx order by 1,2;

SELECT a, ifnull(b,3) AS bxx 
        FROM t1 where b =2
        GROUP BY a, bxx order by a,bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by a,bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where bxx is null
        GROUP BY a, bxx order by a,bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(b,2)=2
        GROUP BY a, bxx order by a,bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where ifnull(bxx,2)=2
        GROUP BY a, bxx order by a,bxx order by 1,2;

--
SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,b order by 1,2;

SELECT a, ifnull(b,-1) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,b order by 1,2;

SELECT a, ifnull(b,4) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,b order by 1,2;


SELECT a, ifnull(b,4) AS bxx 
        FROM t1 
        GROUP BY a, b order by a,bxx order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, b order by a,b order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b=2
        GROUP BY a, bxx order by a,bxx order by 1,2;


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, cast(bxx as varchar(2))='2'  order by 1,2;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, cast(b as varchar(2))='2'  order by 1,2;

SELECT a, b
        FROM t1 
        GROUP BY a, cast(b as varchar(2))='3' order by 1,2 ;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, bxx order by a,bxx;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 where b is null
        GROUP BY a, b order by a,b;

drop table if exists t1;


--+ holdcas off;
commit;