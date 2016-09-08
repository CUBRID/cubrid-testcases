--CBRD-20465 [HA] DDL Query with C-Style comments do not replicate.

--+ holdcas on;
drop table if exists tbl1,tbl2,tbl3,table1,table2,table3;

create table tbl1 (
/************************************************
 * create table
 ***********************************************/
  id int primary key,
  name varchar(200)
);

create table tbl2 (
  id int primary key,
/************************************************
 * name varchar(200)
 ***********************************************/
  age int
);

create table tbl3 (
  id int primary key,
  name /* char(100)  */ varchar(200),
  age /*! char(4)  */ int
);

ALTER TABLE tbl1 
/************************************************
this is a comment
 ***********************************************/
COMMENT ='this is new comment for tbl1';

ALTER TABLE tbl2 COMMENT = /* 'this is a comment' */ 'this is new comment for tbl2';

RENAME TABLE /* 'this is a comment' */ tbl1 to table1;

RENAME TABLE tbl2 /* 'this is a comment' */ to table2, /*! this is a comment */ tbl3 to table3;

DROP TABLE /* 'this is a comment' */IF EXISTS tbl1;

DROP /* 'this is a comment' */ TABLE /*! this is a comment */ IF EXISTS tbl2, /****comment***/tbl3;

DROP /* 'this is a comment' */ table1,
/************************************************
this is a comment
 ***********************************************/
table2,  /* 'this is a comment' */ table3;

CREATE TABLE a_tbl(A INT  /* comment */ AUTO_INCREMENT(3,10) /* comment */ PRIMARY KEY);

INSERT INTO a_tbl VALUES (NULL),(NULL),(NULL);

SELECT * FROM a_tbl;

TRUNCATE 
/************************************************
this is a comment
 ***********************************************/
TABLE /* comment */ a_tbl;

INSERT INTO a_tbl VALUES (NULL);
SELECT * FROM a_tbl;
DROP TABLE IF EXISTS a_tbl;

CREATE TABLE tbl1 (a INT);

GRANT ALL PRIVILEGES/* comment */ ON tbl1 TO 
/************************************************
* this is a comment
 ***********************************************/
public;

CREATE USER user1 ;

GRANT SELECT, INSERT
/************************************************
* this is a comment
 ***********************************************/
, UPDATE, DELETE ON tbl1
/* comment */TO user1;

REVOKE INSERT, UPDATE, 
/************************************************
* this is a comment
 ***********************************************/
DELETE ON /* comment */tbl1 FROM user1;

DROP TABLE IF EXISTS tbl1;
drop user user1;



CREATE TABLE participant2 (
    host_year INT
)
PARTITION BY /*comment*/ RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
/************************************************
* this is a comment
 ***********************************************/
    PARTITION before_2008 VALUES LESS THAN (2008)
);

ALTER TABLE participant2 ADD /****/ PARTITION (
  PARTITION before_2012 VALUES LESS THAN (2012),
  PARTITION last_one VALUES LESS THAN MAXVALUE
/************************************************
* this is a comment
 ***********************************************/
)/* comment */;

CREATE /* comment */TABLE nation2 (
  code /* comment */CHAR (3),
  name VARCHAR (50)
)
/************************************************
* this is a comment
 ***********************************************/
PARTITION BY HASH /* comment */(code) PARTITIONS 4;

ALTER TABLE nation2 /* comment */ COALESCE /* comment */ PARTITION
/************************************************
* this is a comment
 ***********************************************/
1;

CREATE TABLE athlete2 (name VARCHAR (40), event VARCHAR (30))
/************************************************
* this is a comment
 ***********************************************/
PARTITION BY LIST (event) (
    PARTITION event1 VALUES IN ('Swimming',/* comment */ 'Athletics'),
    PARTITION event2 VALUES IN ('Judo', 'Taekwondo', 'Boxing'),
    PARTITION event3 /* comment */VALUES IN ('Football', 'Basketball', 'Baseball')
);

ALTER TABLE athlete2
/************************************************
* this is a comment
 ***********************************************/
REORGANIZE PARTITION event2 INTO (
    PARTITION event2_1 VALUES IN /* comment */('Judo'),
    PARTITION event2_2 /* comment */VALUES IN ('Taekwondo', 'Boxing')
);

ALTER TABLE athlete2/* comment */
REORGANIZE PARTITION event2_1, event2_2 INTO (
/************************************************
* this is a comment
 ***********************************************/
    PARTITION event2 VALUES/* comment */ IN/* comment */ ('Judo', 'Taekwondo', 'Boxing')
);

DROP TABLE IF EXISTS participant2, nation2, 
/************************************************
* this is a comment
 ***********************************************/athlete2;

--+ holdcas off;
