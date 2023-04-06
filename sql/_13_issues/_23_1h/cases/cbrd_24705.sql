-- This test case verifies CBRD-24705 issue.
-- When attempting a covered index scan in a connect by query,
-- encountering 'Execute: Query execution failure'.

DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl (p INT, x INT, y VARCHAR);
CREATE INDEX idx ON tbl (p, x, y);
INSERT INTO tbl VALUES (0, 1, 'A');
INSERT INTO tbl VALUES (1, 2, 'B');

SELECT /*+ RECOMPILE */ x, y AS PATH
FROM tbl
START WITH p = 0
CONNECT BY PRIOR x = p;

INSERT INTO tbl VALUES (2, 3, 'C');
SELECT /*+ RECOMPILE */ x, y AS PATH
FROM tbl
START WITH p = 0
CONNECT BY PRIOR x = p;

SELECT /*+ RECOMPILE NO_COVERING_IDX */ x, y AS PATH
FROM tbl
START WITH p = 0
CONNECT BY PRIOR x = p;


DROP TABLE tbl;
