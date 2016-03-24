--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t1 (id INT, title VARCHAR(100));
INSERT INTO t1 SELECT ROWNUM, 'test-'||ROWNUM FROM db_class limit 30;
CREATE INDEX t1_id ON t1(id);

--TEST: CUBRID should support KEYLIMIT
SELECT /*+ RECOMPILE */ id,title FROM t1 WHERE id BETWEEN 1 AND 20 USING INDEX t1_id KEYLIMIT 1, 5;

--TEST: CUBRID should support KEYLIMIT. Ignore 'from' value
SELECT /*+ RECOMPILE */ id,title FROM t1 WHERE id BETWEEN 1 AND 20 USING INDEX t1_id KEYLIMIT 5;

DROP TABLE t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
