--03_natural_join_bug_from_web_005.sql
--bug CUBRIDSUS-12865
drop table if exists a,c;
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

select * from a natural join c order by 1,2,3,4;
drop table if exists a,c;


--bug CUBRIDSUS-12866
--bug CUBRIDSUS-14291
drop table if exists involvedParties,events,todos,calendarEntries;
CREATE TABLE `calendarEntries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `involvedParties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calendarEntryId` int(11) NOT NULL,
  `listOrder` int(11) NOT NULL,
  `personId` int(11) DEFAULT NULL,
  `companyId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `involvedParties_calendarEntryId_listOrder_uk` (`calendarEntryId`,`listOrder`),
  UNIQUE KEY `involvedParties_personId_calendarEntryId_uk` (`personId`,`calendarEntryId`),
  UNIQUE KEY `involvedParties_companyId_calendarEntryId_uk` (`companyId`,`calendarEntryId`),
  CONSTRAINT `involvedParties_calendarEntryId_fk` FOREIGN KEY (`calendarEntryId`) REFERENCES `calendarEntries` (`id`) ON DELETE CASCADE
) ;


CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calendarEntryId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `creationTimestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastModificationTimestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `startTimestamp` timestamp NULL DEFAULT NULL,
  `startDate` date DEFAULT NULL,
  `endTimestamp` timestamp NULL DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `notes` blob,
  PRIMARY KEY (`id`),
  UNIQUE KEY `events_calendarEntryId_uk` (`calendarEntryId`),
  CONSTRAINT `events_calendarEntryId_fk` FOREIGN KEY (`calendarEntryId`) REFERENCES `calendarEntries` (`id`) ON DELETE CASCADE
);

CREATE TABLE `todos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calendarEntryId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `creationTimestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastModificationTimestamp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `closingTimestamp` timestamp NULL DEFAULT NULL,
  `assigneePersonId` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `startTimestamp` timestamp NULL DEFAULT NULL,
  `startDate` date DEFAULT NULL,
  `dueTimestamp` timestamp NULL DEFAULT NULL,
  `dueDate` date DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `notes` blob,
  PRIMARY KEY (`id`),
  UNIQUE KEY `todos_calendarEntryId_uk` (`calendarEntryId`),
  KEY `todos_assigneePersonId_k` (`assigneePersonId`),
  CONSTRAINT `todos_calendarEntryId_fk` FOREIGN KEY (`calendarEntryId`) REFERENCES `calendarEntries` (`id`) ON DELETE CASCADE
) ;

SELECT * FROM
    involvedParties
NATURAL JOIN (
    calendarEntries
   NATURAL  LEFT JOIN events 
   NATURAL LEFT JOIN todos 
) ;


SELECT * FROM
    involvedParties
NATURAL JOIN 
    calendarEntries
    NATURAL LEFT JOIN events 
    NATURAL LEFT JOIN todos ;

drop table if exists involvedParties,events,todos,calendarEntries;

-----------------------------------
drop table if exists t1,t2,t3,t4;
create table t1(c1 int primary key, c2 char(10));
create table t2(c1 int primary key, c2 char(10), ref_t1 int);
create table t3(c1 int primary key, c2 char(10), ref_t1 int);
create table t4(c1 int primary key, c2 char(10), ref_t1 int);
insert into t1 values(1,'a');
insert into t2 values(1,'a', 1);
insert into t3 values(1,'a', 1);
insert into t4 values(1,'a', 1);
insert into t4 values(2,'a', 2);
insert into t4 values(3,'a', 3);
insert into t4 values(4,'a', 4);
insert into t1 values(2,'b');
insert into t1 values(3,'c');

select * from t4 join t1 join (select * from t3 order by 1,2) t3 join (select * from t2 order by 1,2) t2 on t2.c1 = t3.c1 or t4.c1=t3.c1 order by 1,2,3,4,5;
select * from t4 natural join t1 natural join (select * from t3 order by 1,2) t3 natural join (select * from t2 order by 1,2) t2;
select * from t4 natural join t1 natural join (select * from t3 order by 1,2) t3 join (select * from t2 order by 1,2) t2;
select * from t4 natural join t1 join (select * from t3 order by 1,2) t3 join (select * from t2 order by 1,2) t2;

drop table if exists t1,t2,t3,t4;
-----------------------------------


drop table if exists c;
CREATE TABLE `C` (
  `pk` int(11) NOT NULL AUTO_INCREMENT,
  `col_int_key` int(11) DEFAULT NULL,
  `col_varchar_key` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`pk`)
) ;
INSERT INTO `C` VALUES (1,2,'w');
INSERT INTO `C` VALUES (2,9,'m');
INSERT INTO `C` VALUES (3,3,'m');
INSERT INTO `C` VALUES (4,9,'k');
INSERT INTO `C` VALUES (5,NULL,'r');
INSERT INTO `C` VALUES (6,9,'t');
INSERT INTO `C` VALUES (7,3,'j');
INSERT INTO `C` VALUES (8,8,'u');
INSERT INTO `C` VALUES (9,8,'h');
INSERT INTO `C` VALUES (10,53,'o');
INSERT INTO `C` VALUES (11,0,NULL);
INSERT INTO `C` VALUES (12,5,'k');
INSERT INTO `C` VALUES (13,166,'e');
INSERT INTO `C` VALUES (14,3,'n');
INSERT INTO `C` VALUES (15,0,'t');
INSERT INTO `C` VALUES (16,1,'c');
INSERT INTO `C` VALUES (17,9,'m');
INSERT INTO `C` VALUES (18,5,'y');
INSERT INTO `C` VALUES (19,6,'f');
INSERT INTO `C` VALUES (20,2,'d');

SELECT table1.pk, table2.col_int_key, table1.col_int_key, table2.pk 
FROM C table1  RIGHT  JOIN C table2  ON table2 .`col_int_key`  = table1 .`col_int_key`
WHERE table2 .`pk` order by 1,2,3,4;

SELECT table1.pk, table2.col_int_key, table1.col_int_key, table2.pk 
FROM C table1  LEFT  JOIN C table2  ON table2 .`col_int_key`  = table1 .`col_int_key`
WHERE table2 .`pk` order by 1,2,3,4;

SELECT table1.pk, table2.col_int_key, table1.col_int_key, table2.pk 
FROM C table1  JOIN C table2  ON table2 .`col_int_key`  = table1 .`col_int_key`
WHERE table2 .`pk` order by 1,2,3,4;

SELECT table1.pk, table2.col_int_key, table1.col_int_key, table2.pk 
FROM C table1  NATURAL RIGHT  JOIN C table2 
WHERE table2 .`pk` order by 1,2,3,4;

SELECT table1.pk, table2.col_int_key, table1.col_int_key, table2.pk 
FROM C table1  NATURAL LEFT  JOIN C table2
WHERE table2 .`pk` order by 1,2,3,4;

SELECT table1.pk, table2.col_int_key, table1.col_int_key, table2.pk 
FROM C table1  NATURAL JOIN C table2 
WHERE table2 .`pk` order by 1,2,3,4;


drop table C;



drop table if exists btFiles_comments,comments_votes;
CREATE TABLE `btFiles_comments` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(8) NOT NULL default '0',
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00' ,
  `classification` enum('none','fake','misnamed','spam','pwed') NOT NULL default 'none',
  `hash` varchar(40) NOT NULL,
  `poster_ip` varchar(15) NOT NULL,
  `content`  varchar(15) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `classification` (`classification`),
  KEY `hash` (`hash`)
) ;

CREATE TABLE `comments_votes` (
  `comment_id` int(11) NOT NULL default '0',
  `user_id` int(8) NOT NULL default '0',
  `vote` int(10) NOT NULL default '1',
  `voted_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `user_ip` varchar(15) NOT NULL,
  PRIMARY KEY  (`comment_id`,`user_id`)
) ;

SELECT  content, IFNULL(sum(v.vote),0) as cvotes FROM btFiles_comments c left join comments_votes v on c.id=v.comment_id group by content;

SELECT t1.* FROM (SELECT  c.content, IFNULL(sum(v.vote),0) as cvotes FROM 
btFiles_comments c left join comments_votes v on c.id=v.comment_id group by content) t1;

SELECT content, sum(1) as cvotes FROM btFiles_comments c group by content;

select t1.* from (SELECT content, sum(1) as cvotes FROM btFiles_comments c group by content) t1 ;

---
SELECT  content, IFNULL(sum(v.vote),0) as cvotes FROM btFiles_comments c natural left join comments_votes v group by content;

SELECT t1.* FROM (SELECT  c.content, IFNULL(sum(v.vote),0) as cvotes FROM 
btFiles_comments c natural left join comments_votes v group by content) t1;


drop table if exists btFiles_comments,comments_votes;
---------------------------------

drop v1;
drop table t1;
drop table t2;

CREATE TABLE t1 (
  id INT,
  i1 INT,
  i2 INT DEFAULT 0,
  d1 DATE DEFAULT '2000-01-01',
  d2 DATE DEFAULT '2000-01-01',
  t1 TIME DEFAULT '00:00:00',
  t2 TIME DEFAULT '00:00:00',
  dt1 DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00',
  dt2 DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00',
  c1 VARCHAR(1) NOT NULL,
  c2 VARCHAR(1) NOT NULL
) ;

CREATE VIEW v1 AS SELECT * from (select * from t1 order by 1,2) t1;

INSERT INTO t1 (id,i1,c1,c2) VALUES (1,7,'t','t');
INSERT INTO t1 (id,i1,c1,c2) VALUES (2,4,'k','k');

CREATE TABLE t2 (i INT);
INSERT INTO t2 VALUES (7);
INSERT INTO t2 VALUES (8);


SELECT DISTINCT alias1.id  FROM t1 AS alias1 NATURAL JOIN v1 AS alias2 NATURAL JOIN t2 AS alias3 WHERE alias3.i != 3;

SELECT DISTINCT alias1.id  FROM t1 AS alias1 NATURAL JOIN (v1 AS alias2 NATURAL JOIN t2 AS alias3) WHERE alias3.i != 3;

SELECT DISTINCT alias1.id  FROM t1 AS alias1 NATURAL JOIN v1 AS alias2 NATURAL JOIN t2 AS alias3 WHERE alias3.i != 3;


drop v1;
drop table if exists t1,t2;
