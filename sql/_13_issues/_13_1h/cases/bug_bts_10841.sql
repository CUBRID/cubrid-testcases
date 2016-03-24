CREATE TABLE t1(e ENUM('a', 'b', 'c', 'd', 'e') DEFAULT 'a' NOT NULL, correct_order int); 
CREATE INDEX idx_t1 ON t1(e); 
INSERT INTO t1 VALUES (3,3), (1,1), (2,2), (5,5), (4,4); 
SELECT * FROM t1 ORDER BY 1;
SELECT * FROM t1 ORDER BY 1 desc;
SELECT * FROM t1 ORDER BY e;
SELECT * FROM t1 ORDER BY e desc;
drop table t1;

CREATE TABLE t1(e ENUM( 'b', 'd', 'e', 'c', 'a') DEFAULT 'a' NOT NULL, correct_order int);
CREATE INDEX idx_t1 ON t1(e);
INSERT INTO t1 VALUES (3,3), (1,1), (2,2), (5,5), (4,4);
SELECT * FROM t1 ORDER BY 1;
SELECT * FROM t1 ORDER BY 1 desc;
SELECT * FROM t1 ORDER BY e;
SELECT * FROM t1 ORDER BY e desc;
drop table t1;

CREATE TABLE participant2 (host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT, e enum('a', 'c', 'b', 'e', 'd', 'x', 'y', 'z') )
PARTITION BY RANGE (host_year)
(PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );
 
INSERT INTO participant2 VALUES (1988, 'NZL', 3, 2, 8, 3);
INSERT INTO participant2 VALUES (1988, 'CAN', 3, 2, 5, 1);
INSERT INTO participant2 VALUES (1996, 'KOR', 7, 15, 5, 2);
INSERT INTO participant2 VALUES (2000, 'RUS', 32, 28, 28, 5);
INSERT INTO participant2 VALUES (2004, 'JPN', 16, 9, 12, 4);
select * from participant2 order by e;
drop table participant2;

