--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t1 (col1 INT PRIMARY KEY, col2 VARCHAR(100), col3 CHAR(1), col4 DATETIME);
CREATE INDEX t1_1234 ON t1 (col1,col2,col3,col4);
INSERT INTO t1 VALUES (1, 'test', 'F', DATETIME'2010-11-02 18:55:00');

--TEST CASE: An index on each column referenced in the query��s SELECT list
--Below query shoule use index t1_1234.
SELECT /*+ RECOMPILE */ col1,col2,col3,col4 FROM t1;

--TEST CASE: An index on each column referenced in the query��s SELECT and WHERE list
--Below query shoule use index t1_1234.
SELECT /*+ RECOMPILE */ col1,col2,col3,col4 FROM t1 WHERE col1>0 AND col2='test' AND col3='F' AND col4<= DATETIME'2010-11-03 18:55:00';

--TEST CASE: An index on each column referenced in the query��s SELECT and GROUP BY list
--Below query shoule use index t1_1234.
SELECT /*+ RECOMPILE */ col1,col2,col3,col4 FROM t1 ORDER BY col1,col2,col3,col4;

--TEST CASE: An index on each column referenced in the query��s SELECT and ORDER BY list
--Below query shoule use index t1_1234.
SELECT /*+ RECOMPILE */ col1,col2,col3,col4 FROM t1 GROUP BY col1,col2,col3,col4;

DROP TABLE t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
