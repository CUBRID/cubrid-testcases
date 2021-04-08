--+ holdcas on;
CREATE TABLE t1 ( a INT, b VARCHAR(50));
CREATE INDEX t1_b ON t1 (b);
INSERT INTO t1 SELECT ROWNUM, 'acceptance testing ' || ROWNUM FROM db_class LIMIT 10;
INSERT INTO t1 SELECT 10+ROWNUM, 'full testing ' || ROWNUM FROM db_class LIMIT 10;

SELECT /*+ RECOMPILE */ a,b FROM t1 WHERE b LIKE 'full%';

SELECT /*+ RECOMPILE */ a,b FROM t1 WHERE b LIKE '%testing 3' order by a;

SELECT /*+ RECOMPILE */ a,b FROM t1 WHERE b LIKE '%test%' order by a;

DROP TABLE t1;
commit;
--+ holdcas off;
