--+ holdcas on;
drop table if exists t;
CREATE TABLE t(i INT , j INT ,unique(i,j)) PARTITION BY RANGE(i) (PARTITION p0 VALUES LESS THAN(10), PARTITION p1 VALUES LESS THAN(100));
--insert tuple (1, 10) in partition p0 and tuple (50, 11) in partition p1
INSERT INTO t VALUES(1,10), (50, 11);
REPLACE INTO t PARTITION (p0) VALUES(50, 11);
REPLACE INTO t PARTITION (p0) VALUES(2, 11);
drop table if exists t;


drop table if exists t;
CREATE TABLE t(i INT, j INT) PARTITION BY RANGE(i) (PARTITION p0 VALUES LESS THAN(10), PARTITION p1 VALUES LESS THAN(100));
--insert tuple (1, 10) in partition p0 and tuple (50, 11) in partition p1
INSERT INTO t VALUES(1,10), (50, 11);
UPDATE t PARTITION (p0) SET i = 2 WHERE i = 1;
drop table if exists t;

drop table if exists t;
CREATE TABLE t(i INT, j INT) PARTITION BY RANGE(i) (PARTITION p0 VALUES LESS THAN(10), PARTITION p1 VALUES LESS THAN(100));
--insert tuple (1, 10) in partition p0 and tuple (50, 11) in partition p1
INSERT INTO t VALUES(1,10), (50, 11);
UPDATE t PARTITION (p0) SET i = 20 WHERE i = 11;
drop table if exists t;

drop table if exists t;
CREATE TABLE t(i INT, j INT) PARTITION BY RANGE(i) (PARTITION p0 VALUES LESS THAN(10), PARTITION p1 VALUES LESS THAN(100));
--insert tuple (1, 10) in partition p0 and tuple (50, 11) in partition p1
INSERT INTO t VALUES(1,10), (50, 11);
UPDATE t PARTITION (p0) SET i = 20 WHERE i = 1;
drop table if exists t;


drop table if exists t;
CREATE TABLE t(i INT) PARTITION BY RANGE(i) (PARTITION p0 VALUES LESS THAN(10), PARTITION p1 VALUES LESS THAN(100));
INSERT INTO t VALUES(1);
SELECT t INTO :my_obj FROM t;
UPDATE OBJECT :my_obj SET i = 3;
UPDATE OBJECT :my_obj SET i = 33;
drop table if exists t;


--+ holdcas off;
