--+ holdcas on;
CREATE TABLE t1 ( a INT, d VARCHAR(50));
INSERT INTO t1 SELECT ROWNUM, 'record-'||ROWNUM FROM db_class LIMIT 20;
CREATE INDEX idx_t1_a ON t1(a);

--TEST: descending index scan
SELECT /*+ RECOMPILE */ a,d FROM t1 WHERE a BETWEEN 5 AND 15 ORDER BY a DESC;

--TEST: support hint desc_scan_hint
SELECT /*+ use_desc_idx RECOMPILE */ a,d FROM t1 WHERE a BETWEEN 5 AND 15 USING INDEX idx_t1_a;


DROP TABLE t1;
commit;
--+ holdcas off;
