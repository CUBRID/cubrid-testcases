-- This case verifies CBRD-25067 issue.
-- ORDER BY causes row to be omitted with index and case expression


DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl(col INT UNIQUE);
INSERT INTO tbl(col) VALUES (NULL);

SELECT /*+ recompile */ * FROM tbl WHERE (CASE col WHEN 0 THEN 1 ELSE 0 END = 0) ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE col is null ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE col is not null ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE col > 0 ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE NVL(col,0)=0 ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE DECODE(col,1,5,0)=0 ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE COALESCE(col, 0)=0 ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE NVL2(col, 1, 0)=0 ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE IF(col = 1, 1, 0)=0 ORDER BY col;
SELECT /*+ recompile */ * FROM tbl WHERE CONCAT_WS(col, 'ab', 'cd') IS NULL ORDER BY col;

DROP TABLE tbl;
