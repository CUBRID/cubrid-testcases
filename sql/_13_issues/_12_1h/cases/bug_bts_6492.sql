CREATE TABLE t1 (a char (10) , unique(a));
INSERT INTO t1 VALUES ('a');
UPDATE t1 SET a='a ' WHERE a LIKE 'a ';
UPDATE t1 SET a='a ' WHERE a LIKE 'a ';
update t1 set a = 'a ' where a like 'a_';
update t1 set a = 'a ' where a like 'a';

drop table t1;
