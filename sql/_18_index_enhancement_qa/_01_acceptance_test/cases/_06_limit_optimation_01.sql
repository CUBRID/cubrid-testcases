--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t1 ( a INT, b INT);

INSERT INTO t1 VALUES (11, 1);
INSERT INTO t1 VALUES (12, 1);
INSERT INTO t1 SELECT ROWNUM, ROWNUM FROM db_class LIMIT 10;
INSERT INTO t1 VALUES (13, 1);
INSERT INTO t1 VALUES (14, 1);
INSERT INTO t1 VALUES (15, 1);

CREATE INDEX idx_t1_a ON t1(a);
CREATE INDEX idx_t1_b ON t1(b);

--TEST: rownum rewrite
SELECT /*+ RECOMPILE */ a,b FROM t1 WHERE a>0 ORDER BY a LIMIT 5;

--TEST: rownum rewrite could not be adopt, but require TOP N sorting
SELECT /*+ RECOMPILE */ a,b FROM t1 WHERE b=1 ORDER BY a LIMIT 5;

DROP TABLE t1;set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
