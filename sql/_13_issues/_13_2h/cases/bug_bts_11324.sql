-- Test Collation inference should be supported with UNION statement

-- scenario1
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

CREATE TABLE t1 (s1 STRING COLLATE utf8_en_ci);
CREATE TABLE t2 (s2 STRING COLLATE utf8_en_cs);
CREATE TABLE t3 (s3 STRING COLLATE utf8_tr_cs);
 
insert into t1 values ('a');
insert into t2 values ('a');
insert into t2 values ('b');
insert into t3 values ('c');
 
SELECT CONCAT(s1,'') FROM t1
UNION
SELECT CONCAT(s2,'') FROM t2
UNION
SELECT s3 FROM t3;
 
SELECT s3 FROM t3
UNION
SELECT CONCAT(s2,'') FROM t2
UNION
SELECT CONCAT(s1,'') FROM t1;

drop t1;
drop t2;
drop t3;


-- scenario2 for binary collation
CREATE TABLE t1 (s1 STRING COLLATE euckr_bin);
CREATE TABLE t2 (s2 STRING COLLATE utf8_bin);
CREATE TABLE t3 (s3 STRING COLLATE iso88591_bin);

insert into t1 values ('a');
insert into t2 values ('a');
insert into t2 values ('b');
insert into t3 values ('c');

SELECT CONCAT(s1,'') FROM t1
UNION
SELECT CONCAT(s2,'') FROM t2
UNION
SELECT s3 FROM t3;

SELECT s3 FROM t3
UNION
SELECT CONCAT(s2,'') FROM t2
UNION
SELECT CONCAT(s1,'') FROM t1;

drop t1;
drop t2;
drop t3;
