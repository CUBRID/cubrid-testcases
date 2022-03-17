--+ holdcas on;
drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,NULL,2); 
INSERT INTO t1 VALUES(2,2,2); 


SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by 1;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx with rollup order by 1;

SELECT a, ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY a, cast(bxx as varchar(2))='2'  order by 1;


SELECT  ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY 1  order by 1;

SELECT  ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY cast(bxx as varchar(2))='4'  order by 1;

SELECT  ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY cast(b as varchar(2))='4'  order by 1;

SELECT  ifnull(b,2) AS bxx 
        FROM t1 
        GROUP BY cast(bxx as varchar(2))='2'  order by 1;

SELECT ifnull(b,2) AS bxx  
        FROM t1 
        GROUP BY cast(b as varchar(2))='2' order by 1 ;

SELECT b 
        FROM t1 
        GROUP BY cast(b as varchar(2))='2'  order by 1;

drop table if exists t1;

---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1(a INT, bxx INT, c INT); 
INSERT INTO t1 VALUES(1,1,1); 
INSERT INTO t1 VALUES(2,2,2); 

SELECT a, bxx 
        FROM t1 
        GROUP BY  rollup(a,bxx) order by 1;

SELECT a, bxx 
        FROM t1 
        GROUP BY a,bxx with rollup order by 1;

SELECT a, bxx 
        FROM t1 
        GROUP BY a, bxx with rollup order by 1;

SELECT a, ifnull(thasnoattributeb,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by 1;

SELECT a, thasnoattributeb
        FROM t1 
        GROUP BY a, thasnoattributeb with rollup order by 1;

SELECT a, ifnull(thasnoattributeb,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx order by 1;

SELECT a, ifnull(thasnoattributeb,2) AS bxx 
        FROM t1 
        GROUP BY a, bxx with rollup order by 1;

SELECT a, ifnull;

SELECT a, b
        FROM t1 
        GROUP BY a, b with rollup order by 1;


drop table if exists t1;
---------------------------------------------------

DROP TABLE IF EXISTS `e`,`s`;
CREATE TABLE `e` (
  `rid` int(10) NOT NULL AUTO_INCREMENT,
  `scode` varchar(40) DEFAULT NULL,
  `f_dt1` date DEFAULT NULL,
  `f_dt2` date DEFAULT NULL,
  PRIMARY KEY (`rid`),
  KEY `f_dt1` (`f_dt1`),
  KEY `f_dt2` (`f_dt2`),
  KEY `scode` (`scode`)
) ;

INSERT INTO `e` VALUES
(962328,'ABC1216',NULL,'2014-01-31'),
(962330,'ABC1217','2014-01-23','2014-01-23'),
(963122,'ABC1219',NULL,NULL),
(967451,'ABC1217',NULL,NULL);

DROP TABLE IF EXISTS `s`;
CREATE TABLE `s` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `scode` varchar(40) DEFAULT NULL,
  `pcode` varchar(20) NOT NULL,
  PRIMARY KEY (`rid`),
  UNIQUE KEY `scode` (`scode`)
);

INSERT INTO `s` VALUES
(300676, 'ABC1216','ABC'),
(300677, 'ABC1217','ABC'),
(300964, 'ABC1219','ABC');

--
SELECT s.scode

FROM s
LEFT JOIN e  e1  ON e1.scode=s.scode
WHERE s.pcode = 'ABC'

GROUP BY  s.scode
ORDER BY 1 DESC;

--

SELECT 	ifnull(e1.f_dt2,'2014-01-23') as bad FROM  e  e1  order by 1;

SELECT s.scode,	ifnull(e1.f_dt2,'2014-01-23') as bad FROM s LEFT JOIN e  e1  ON e1.scode=s.scode  order by 1;

SELECT s.scode,

concat(
	ifnull(e1.f_dt2,'2014-01-23'),
	'#',
	ifnull(e1.f_dt1,'2014-01-23')
) bad

FROM s
LEFT JOIN e  e1  ON e1.scode=s.scode  order by 1
;


--

SELECT s.scode,

concat(
	ifnull(nullif(e1.f_dt2,'2014-01-23'),''),
	'#',
	ifnull(nullif(e1.f_dt1,'2014-01-23'),'')
) bad,


length(
concat(
	ifnull(nullif(e1.f_dt2,'2014-01-23'),''),
	'#',
	ifnull(nullif(e1.f_dt1,'2014-01-23'),'')
)) bad_len,

concat(
	ifnull(nullif(cast(e1.f_dt2 as char(20)),'2014-01-23'),''),
	'#',
	ifnull(nullif(cast(e1.f_dt1 as char(20)),'2014-01-23'),'')
) good,

length(
concat(
	ifnull(nullif(cast(e1.f_dt2 as char(20)),'2014-01-23'),''),
	'#',
	ifnull(nullif(cast(e1.f_dt1 as char(20)),'2014-01-23'),'')
)) good_len

FROM s
LEFT JOIN e  e1  ON e1.scode=s.scode
WHERE s.pcode = 'ABC' and s.scode='ABC1217'

GROUP BY  s.scode
ORDER BY 1 DESC,2,3,4;
---

SELECT s.scode,

concat(
	ifnull(nullif(cast(e1.f_dt2 as char(10)),'2014-01-23'),''),
	'#',
	ifnull(nullif(cast(e1.f_dt1 as char(10)),'2014-01-23'),'')
) good,

length(
concat(
	ifnull(nullif(cast(e1.f_dt2 as char(10)),'2014-01-23'),''),
	'#',
	ifnull(nullif(cast(e1.f_dt1 as char(10)),'2014-01-23'),'')
)) good_len

FROM s
LEFT JOIN e  e1  ON e1.scode=s.scode
WHERE s.pcode = 'ABC' and s.scode='ABC1217'

GROUP BY  s.scode
ORDER BY 1 DESC,2,3,4;

--
SELECT s.scode,
cast(e1.f_dt2 as char(10)),
	ifnull(nullif(cast(e1.f_dt2 as char(10)),'2014-01-23'),'')
FROM s
LEFT JOIN e  e1  ON e1.scode=s.scode
WHERE s.pcode = 'ABC' and s.scode='ABC1217'

GROUP BY  s.scode
ORDER BY 1 DESC,2,3,4;

--
SELECT s.scode,
cast(e1.f_dt2 as char(10)),
	nullif(cast(e1.f_dt2 as char(10)),'2014-01-23')
FROM s
LEFT JOIN e  e1  ON e1.scode=s.scode
WHERE s.pcode = 'ABC' and s.scode='ABC1217'

GROUP BY  s.scode
ORDER BY 1 DESC,2,3,4;

DROP TABLE IF EXISTS `e`,`s`;
---------------------------------------------------

drop table if exists test;
create table test(
firstdate datetime default null,
lastdate datetime default null
);
insert into test(firstdate, lastdate) values('2014-03-08', '2012-03-08');
insert into test(firstdate, lastdate) values('2013-03-08', '2011-03-08');
select GREATEST( IFNULL(MAX(firstdate), 0), IFNULL(MAX(lastdate), 0)) from test order by 1,2;
-- expect: '2014-03-08 00:00:00'. got it.
select * from (select GREATEST( IFNULL(MAX(firstdate), 0), IFNULL(MAX(lastdate), 0)) from test ) t order by 1,2;
-- expect: '2014-03-08 00:00:00'. got '2014-0'
select * from (select GREATEST( IFNULL(MAX(firstdate), '0000-00-00 00:00:00'), IFNULL(MAX(lastdate), '0000-00-00 00:00:00')) from test) t order by 1,2;
drop table if exists test;


--+ holdcas off;
commit;
