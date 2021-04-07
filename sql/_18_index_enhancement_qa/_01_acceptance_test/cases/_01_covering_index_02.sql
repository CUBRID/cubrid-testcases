--+ holdcas on;
CREATE TABLE t1 (col1 INT PRIMARY KEY, col2 VARCHAR(100), col3 CHAR(1), col4 DATETIME);
CREATE INDEX tx_all ON t1 (col1,col2,col3,col4);
INSERT INTO t1 VALUES (1, 'test', 'F', DATETIME'2010-11-02 18:55:00');

CREATE TABLE t2 (col1 INT PRIMARY KEY, col2 VARCHAR(100), col3 CHAR(1), col4 DATETIME);
CREATE INDEX ty_all ON t2 (col1,col2,col3,col4);
INSERT INTO t2 VALUES (1, 'test', 'F', DATETIME'2010-11-02 18:55:00');

--TEST: Queries with joins
--Below query shoule use index tx_all and ty_all.
SELECT /*+ RECOMPILE */ t1.col1,t1.col2,t2.col3,t2.col4 FROM t1,t2 WHERE t1.col1>0;

DROP TABLE t1;
DROP TABLE t2;
commit;
--+ holdcas off;
