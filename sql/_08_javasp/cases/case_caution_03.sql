CREATE OR REPLACE FUNCTION intTest(x int) RETURN int AS LANGUAGE JAVA NAME 'SpTest7.typetestint(int) return int';

DROP IF EXISTS tbl1;

CREATE TABLE tbl1 (col1 INT, col2 INT);
CREATE INDEX i_tbl1 ON tbl1 (col1);

INSERT INTO tbl1 VALUES (1,10);
INSERT INTO tbl1 VALUES (2,10);
INSERT INTO tbl1 VALUES (3,10);
INSERT INTO tbl1 VALUES (4,10);
INSERT INTO tbl1 VALUES (5,10);
INSERT INTO tbl1 VALUES (6,10);
INSERT INTO tbl1 VALUES (7,10);
INSERT INTO tbl1 VALUES (8,10);
INSERT INTO tbl1 VALUES (9,10);
INSERT INTO tbl1 VALUES (10,10);

SELECT col1, col2, intTest(col1) FROM tbl1 FOR UPDATE;
SELECT col1, col2, intTest(col1) FROM tbl1 ORDER BY intTest(col1) DESC FOR UPDATE;

SELECT col1, col2, intTest(99) FROM tbl1 FOR UPDATE;
-- (Related CBRD-24687) if used 'JAVASP' is in the 'ORDER BY' clause then the query result is a strange
-- If fix the CBRD-24687 then remove this query's comment
--SELECT col1, col2, intTest(99) FROM tbl1 ORDER BY intTest(col1) DESC FOR UPDATE;

DROP FUNCTION intTest;
DROP tbl1;

