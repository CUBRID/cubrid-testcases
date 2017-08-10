--+ holdcas on;
set names utf8;
drop table if exists la,ma ,tr ;
CREATE TABLE la (
   laID INTEGER NOT NULL AUTO_INCREMENT,
   laCode CHAR(10) NOT NULL,
   laName VARCHAR(40) NOT NULL,
   laNameID INTEGER NOT NULL,
   stamp TIMESTAMP ,
   PRIMARY KEY (laID),
   KEY laCode (laCode),
   KEY laNameID (laNameID),
   KEY laName (laName) );

INSERT la SELECT 1, 'E', 'English', 1, null;
INSERT la SELECT 2, 'S', 'Spanish', 2, null;
INSERT la SELECT 3, 'ASL', 'American Sign la', 3, null;
INSERT la SELECT 4, 'LSA', 'Argentinian Sign la', 4, null;

CREATE TABLE ma (
   maID INTEGER NOT NULL AUTO_INCREMENT,
   Mtext VARCHAR(40) NOT NULL,
   stamp TIMESTAMP ,
   PRIMARY KEY (maID) );

INSERT ma SELECT 1, 'English', null;
INSERT ma SELECT 2, 'Spanish', null;
INSERT ma SELECT 3, 'American Sign la', null;
INSERT ma SELECT 4, 'Argentinian Sign la', null;

CREATE TABLE tr (
   trID INTEGER AUTO_INCREMENT,
   maID INTEGER NOT NULL,
   laID INTEGER NOT NULL,
   text VARCHAR(40) NOT NULL,
   stamp TIMESTAMP ,
   PRIMARY KEY (trID),
   KEY maID_laID (maID, laID) );

INSERT tr SELECT null, 1, 1, 'English', null;
INSERT tr SELECT null, 2, 1, 'Spanish', null;
INSERT tr SELECT null, 3, 1, 'American Sign la', null;
INSERT tr SELECT null, 4, 1, 'Argentinian Sign la', null;
INSERT tr SELECT null, 1, 2, 'Inglés', null;
INSERT tr SELECT null, 2, 2, 'Español', null;
INSERT tr SELECT null, 3, 2, 'Lenguaje de señas americano', null;
INSERT tr SELECT null, 4, 2, 'Lengua de señas argentina', null;

SELECT l.laID,
       l.laCode,
       l.laNameID,
       COALESCE(t1.text, tm1.Mtext) AS laName,
       l.stamp
  FROM la l
 INNER JOIN ma tm1
    ON tm1.maID = l.laNameID
  LEFT OUTER JOIN tr t1
    ON t1.maID = l.laNameID
   AND t1.laID = 2
 WHERE l.laName LIKE '%Sign la%'
 ORDER BY laName;

SELECT l.laID,
       l.laCode,
       l.laNameID,
       COALESCE(t1.text, tm1.Mtext) AS laName,
       l.stamp
  FROM la l
 INNER JOIN ma tm1
    ON tm1.maID = l.laNameID
  LEFT OUTER JOIN tr t1
    ON t1.maID = l.laNameID
   AND t1.laID = 2
 WHERE l.laName LIKE '%Sign la%'
 ORDER BY laName;

drop table if exists la,ma ,tr ;
---------------------------------------------------
drop table if exists t1;
CREATE TABLE t1 (a INT, b INT);
INSERT INTO t1 VALUES (1,9), (2, 8), (3, 7);
SELECT a b, b FROM t1 GROUP BY b order by 1,2;
SELECT a b, b FROM t1 GROUP BY b + 0 order by 1,2;
drop table if exists t1;
---------------------------------------------------
drop table if exists groupbyenum ;
drop view test1;
CREATE TABLE groupbyenum (
  id int(10) NOT NULL auto_increment,
  val enum('one','two','three') NOT NULL default 'one',
  PRIMARY KEY  (id)
) ;

INSERT INTO groupbyenum VALUES
(1,'one'),(2,'two'),(3,'three'),(4,'one'),(5,'two');
select val as valx, count(*) from groupbyenum group by val order by 1,2;
select val as valx, count(*) from groupbyenum group by valx order by 1,2;
select val as val, count(*) from groupbyenum group by val order by 1,2;
select val, count(*) from groupbyenum group by val order by 1,2;
select val, count(*) from groupbyenum group by val+0 order by 1,2;
drop table if exists groupbyenum ;
===
drop table if exists test;
create table test (
 col1     character varying(15),
 col2     character(1),
 col3     character(1),
 col7     character(1),
 col5     character varying(10) not null,
 col9     character varying(16),
 col8     character varying(40),
 col6     character varying(16),
 col10    character varying(60),
 col11    character varying(60),
 col12    character varying(60),
 col13    character varying(5),
 col14    character varying(2),
 col15    character varying(40),
 col16    character varying(60),
 col17    character varying(60),
 col18    character varying(60),
 col19    character varying(5),
 col20    character varying(2),
 col4     character varying(3),
 col21    date,
 col22    character varying(4),
 col23    date,
 col24    date DEFAULT '0000-00-00',
 col25    integer,
 col26    date DEFAULT '0000-00-00',
 col27    character(3),
 col28    integer DEFAULT 0,
 col29    character(3),
 col30    character(4),
 col31    character(40),
 col32    character(16),
 col33    character(40),
 col34    character(16),
 col35    date,
 col36    varchar(50),
 col37    varchar(30),
 col38    date,
 col39    varchar(100),
 col40    integer,
 col41    decimal(10,3),
 col42    varchar(4),
 col43    integer DEFAULT 0,
 col44    integer AUTO_INCREMENT PRIMARY KEY
 );

create view test1 as select * from test;

insert into test values('090990074180',NULL,'N','N','S003','0176130090','LU MARIOTTIO','0176130090','LOC.SALMAR','ALMARIN','RZACHEN','07021','SS','ALU MARIOTTI1','LOC.SAL','ALMARIN','HENA EE','07021','SS','1','2004-11-12','02','2004-11-12','0000-00-00',1149,'2004-11-15','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'S.D.A',NULL,'2004-11-16',NULL,15502 ,NULL ,'D02',1, 1);
insert into test values('036990023324',NULL,'N','N','O002','0029298036','RTOLOTTI MAR','0029298036','COMUNAGLIE','ORRE MA','ARANELL','41053','MO','SL DI MODENA1','SASSUOL','ASSUOLO','OLO EEE','41049','MO','1','2003-03-04','17','2003-03-04','0000-00-00', 321,'2003-03-04','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'NULL ',NULL,'2003-03-04',NULL, NULL ,NULL ,'E17',1, 2);
insert into test values('036990023323',NULL,'N','N','O002','0029298036','RTOLOTTI MAR','0029298036','COMUNAGLIE','ORRE MA','ARANELL','41053','MO','SL DI MODENA1','SASSUOL','ASSUOLO','OLO EEE','41049','MO','1','2003-03-04','17','2003-03-04','0000-00-00', 321,'2003-03-04','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'NULL ',NULL,'2003-03-04',NULL, NULL ,NULL ,'E17',1, 3);
insert into test values('036990023322',NULL,'N','N','O002','0029298036','RTOLOTTI MAR','0029298036','COMUNAGLIE','ORRE MA','ARANELL','41053','MO','SL DI MODENA1','SASSUOL','ASSUOLO','OLO EEE','41049','MO','1','2003-03-04','17','2003-03-04','0000-00-00', 321,'2003-03-04','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'NULL ',NULL,'2003-03-04',NULL, NULL ,NULL ,'E17',1, 4);
insert into test values('034990145606',NULL,'N','N','R093','SPGBRO49A2','AGGIARI OBER','SPGBRO49A2','VIA MONZAT','ZZZZZZZ','RAVERSE','43029','PR','PAGGIARI OBER','VIA MON','_______','RSETOLO','43029','PR','1','2004-09-01','07','2004-09-01','0000-00-00',1077,'2004-09-02','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'S.D.A',NULL,'2004-09-03',NULL,14064 ,NULL ,'E07',1, 5);
insert into test values('034990145605',NULL,'N','N','R093','SPGBRO49A2','AGGIARI OBER','SPGBRO49A2','VIA MONZAT','XXXXXXX','RAVERSE','43029','PR','PAGGIARI OBER','VIA MON','_______','RSETOLO','43029','PR','1','2004-09-01','07','2004-09-01','0000-00-00',1077,'2004-09-02','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'S.D.A',NULL,'2004-09-03',NULL,14064 ,NULL ,'E07',1, 6);
insert into test values('034990145604',NULL,'N','N','R093','SPGBRO49A2','AGGIARI OBER','SPGBRO49A2','VIA MONZAT','XXXXXXX','RAVERSE','43029','PR','PAGGIARI OBER','VIA MON','_______','RSETOLO','43029','PR','1','2004-09-01','07','2004-09-01','0000-00-00',1077,'2004-09-02','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'S.D.A',NULL,'2004-09-03',NULL,14064 ,NULL ,'E07',1, 7);
insert into test values('034990145603',NULL,'N','N','R093','SPGBRO49A2','AGGIARI OBER','SPGBRO49A2','VIA MONZAT','XXXXXXX','RAVERSE','43029','PR','PAGGIARI OBER','VIA MON','_______','RSETOLO','43029','PR','1','2004-09-01','07','2004-09-01','0000-00-00',1077,'2004-09-02','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'S.D.A',NULL,'2004-09-03',NULL,14064 ,NULL ,'E07',1, 8);
insert into test values('034990145602',NULL,'N','N','R093','SPGBRO49A2','AGGIARI OBER','SPGBRO49A2','VIA MONZAT','XXXXXXX','RAVERSE','43029','PR','PAGGIARI OBER','VIA MON','_______','RSETOLO','43029','PR','1','2004-09-01','07','2004-09-01','0000-00-00',1077,'2004-09-02','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'S.D.A',NULL,'2004-09-03',NULL,14064 ,NULL ,'E07',1, 9);
insert into test values('034990145601',NULL,'N','N','R093','SPGBRO49A2','AGGIARI OBER','SPGBRO49A2','VIA MONZAT','XXXXXXX','RAVERSE','43029','PR','PAGGIARI OBER','VIA MON','_______','RSETOLO','43029','PR','1','2004-09-01','07','2004-09-01','0000-00-00',1077,'2004-09-02','017',-1,0,NULL,NULL, NULL,NULL,NULL,NULL,'S.D.A',NULL,'2004-09-03',NULL,14064 ,NULL ,'E07',1,10);

SELECT col6,col5,col3,col4,col2,COUNT(*) AS q,group_concat(col1 order by col1) as col1  FROM test1 
GROUP by col6,col5,col3,col4, col2 order by 1,2,3,4,5,6,7;


drop table if exists test;
drop view test1;
drop table if exists test;
---------------------------------------------------
drop table if exists t1;
create table if not exists `t1`(`a` int,`b` varchar(2000));
insert into t1(a,b) values (1,repeat('a',1025)),(2,repeat('a',1024));
select count(*) from `t1` group by `b` order by 1;
select group_concat(`a`), count(*) from `t1` group by `b` order by 1,2;
drop table if exists t1;

---------------------------------------------------
drop table if exists `sort1`;
CREATE TABLE `sort1` (
             `ID` int(11) NOT NULL auto_increment,
             `code` varchar(20) NOT NULL default '0', 
             `company` varchar(255) default '0',
             `book` varchar(30) NOT NULL default '0',
             `fileName` varchar(64) default '0',
             `fileType` int default NULL,
             `fchecksum` int default NULL,
             `status` int default NULL, 
             `ctype` int(11) default NULL, 
             `distribution` int default NULL,
             `Agname` varchar(255)  default NULL, 
             `Agadd1` varchar(255)  default NULL,
             `Agadd2` varchar(255)  default NULL,
             `Agadd3` varchar(255)  default NULL,
             `Agadd4` varchar(255)  default NULL,
             `Agadd5` varchar(255)  default NULL,
             `name` varchar(255)  default NULL, 
             `pdf` varchar(255)  default NULL,
             `ds` varchar(255)  NOT NULL default ''
             );

INSERT INTO sort1 (code, company, book, fileName, fileType, fchecksum, status, ctype, distribution, Agname, Agadd1, Agadd2, Agadd3, Agadd4, Agadd5, name, pdf, ds) 
VALUES('584654', 'company1', '12345678', 'Invoice', 1, 3, 1,
NULL, NULL, 'A Travel Agent', '1 Travel Street', 'Travel Town', 'Travelshire', 
'', 'TV1 1TV', 'The Ninth Traveller', NULL, 'D:\DS5441-1.DAT');

INSERT INTO sort1 (code, company, book, fileName, fileType, fchecksum, status, ctype, distribution, Agname, Agadd1, Agadd2, Agadd3, Agadd4, Agadd5, name, pdf, ds) 
VALUES('584655', 'company1', '12345678', 'Other Doc', 2, 3, 1, 
NULL, NULL, 'A Travel Agent', '1 Travel Street', 'Travel Town', 'Travelshire', 
'', 'TV1 1TV', 'Another Traveller', NULL, 'D:\DS5441-2.DAT');

INSERT INTO sort1 (code, company, book, fileName, fileType, fchecksum, status, ctype, distribution, Agname, Agadd1, Agadd2, Agadd3, Agadd4, Agadd5, name, pdf, ds) 
VALUES('584656', 'company2', '12345679', 'Invoice', 1, 3, 1,
NULL, NULL, 'Another Travel Agent', '2 Travel Road', 'Vacation Town', 'Holidayshire', 
'', 'VA1 1AV', 'Yet Another Traveller', NULL, 'D:\DS5441-3.DAT');

INSERT INTO sort1 (code, company, book, fileName, fileType, fchecksum, status, ctype, distribution, Agname, Agadd1, Agadd2, Agadd3, Agadd4, Agadd5, name, pdf, ds) 
VALUES('584656', 'company2', '12345679', 'Other Doc', 2, 3, 1,
NULL, NULL, 'Another Travel Agent', '2 Travel Road', 'Vacation Town', 'Holidayshire', 
'', 'VA1 1AV', 'Yet Another Traveller', NULL, 'D:\DS5441-3.DAT');

SELECT 
    code, 
    book, 
    fileType, 
    fchecksum 
FROM 
    sort1 
GROUP BY 
    id, 
    book, 
    fileType
HAVING 
    fchecksum != SUM(fileType)  order by 1,2,3,4;
drop table if exists `sort1`;
---------------------------------------------------
drop table if exists t1;
create table t1 (f1 int);
INSERT INTO t1 (f1) VALUES (10), (20);
select (f1 + 100) as an_alias from t1 group by 20 - an_alias  order by 1;
select (f1 + 100) as an_alias from t1 order by an_alias order by 1;
select (f1 + 100) as an_alias from t1 order by 20 - an_alias order by 1;
drop table if exists t1;
---------------------------------------------------
drop table if exists t1;
create table t1 (f1 int);
INSERT INTO t1 (f1) VALUES (10), (20);

select f1 as an_alias from t1 group by an_alias order by 1;
select f1 as an_alias from t1 group by 20 - an_alias order by 1;

select 100 as an_alias from t1 group by 20 -  an_alias order by 1;
select f1, 100 as an_alias from t1 group by 20 - an_alias order by 1;

select (f1 = 100) as an_alias from t1 group by 20 - an_alias order by 1;
select (f1 + 100) as an_alias from t1 group by 20 - an_alias order by 1;

select (f1 + 100) as an_alias from t1 order by an_alias order by 1;

drop table if exists t1;
---------------------------------------------------

drop table if exists foo;
CREATE TABLE foo ( i int(10) );
INSERT INTO foo (i) VALUES (10), (20);
SELECT i AS `BAR` FROM foo GROUP BY `BAR` order by 1;

drop table if exists foo;
---------------------------------------------------
drop table if exists t1;
CREATE TABLE t1 (a INT, b INT);

INSERT INTO t1 VALUES (1,9), (2, 8), (3, 7),(null,1),(null,1),(1,null),(2,null);
select txx.b b from t1 tx join t1 txx on tx.a=txx.a group by txx.b order by 1;
drop table if exists t1;
---------------------------------------------------

drop table if exists t1;
CREATE TABLE t1 (a INT, b INT);

INSERT INTO t1 VALUES (1,9), (2, 8), (3, 7),(null,1),(null,1),(1,null),(2,null);
select ifnull(txx.b,7) bxx, a from t1 tx join t1 txx on tx.a=txx.a group by a having ifnull(bxx,5) order by 1,2;
select ifnull(txx.b,7) bxx, tx.a from t1 tx join t1 txx on tx.a=txx.a group by tx.a order by 1,2;

select ifnull(txx.b,7) bxx from t1 tx join t1 txx on tx.a=txx.a order by 1;
select ifnull(txx.b,7) bxx from t1 tx join t1 txx on tx.a=txx.a group by 0=0 order by 1;


select txx.b b from t1 tx join t1 txx on tx.a=txx.a group by b;

select ifnull(txx.b,7) bxx from t1 tx join t1 txx on tx.a=txx.a group by bxx order by 1;
select ifnull(txx.b,7) bxx from t1 tx join t1 txx on tx.a=txx.a group by 1=0 order by 1;
select ifnull(txx.b,7) bxx from t1 tx join t1 txx on tx.a=txx.a group by ifnull(bxx,5) order by 1;
select txx.b b from t1 tx join t1 txx on tx.a=txx.a group by 1 order by 1;

drop table if exists t1;
---------------------------------------------------
drop table if exists jobs;
CREATE TABLE jobs(id INT, start_at timestamp DEFAULT timestamp'2011-2-3 18:49:32'); 
INSERT INTO jobs VALUES(1,default); 
SELECT COUNT(j.id), DATE(j.start_at) AS `date`
FROM jobs j
GROUP BY `date` order by 1;
drop table if exists jobs;
---------------------------------------------------


drop table if exists `Post`,`PostFavorite`,`User`;
CREATE TABLE `Post` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) NOT NULL,
  `category_id` int(3) NOT NULL,
  `content` varchar(10240) NOT NULL,
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` enum('active','inactive','blocked') NOT NULL DEFAULT 'inactive',
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `PostFavorite` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) NOT NULL,
  `post_id` int(10) NOT NULL,
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE `User` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `email` varchar(64) NOT NULL DEFAULT '',
  `state` enum('new','active','blocked','readonly') NOT NULL DEFAULT 'new',
  PRIMARY KEY (`id`)
) ;
SELECT t.user_id AS c, COUNT(*) AS s FROM PostFavorite t INNER JOIN Post posts ON posts.id = t.post_id WHERE (posts.state = 'active') AND (t.user_id='1') GROUP BY t.user_id order by 1,2;

drop table if exists `Post`,`PostFavorite`,`User`;

set names iso88591;
--+ holdcas off;
commit;
