--This is a test case to test whether the javasp function supports the SQL-Comparison function

DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl(col1 INT, col2 INT, col3 INT);
INSERT INTO tbl(col1) VALUES (1),(2),(3);
CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION test_fc2(i double) RETURN double as language java name 'SpTest7.typetestdouble1(double) return double';

SELECT col1, DECODE(col1,test_fc(1),'1',test_fc(2),'2',test_fc(3),'3') FROM tbl;
SELECT col1, DECODE(col1, 1, test_fc(1), 2, test_fc2(1.2), test_fc2(1.234)) FROM tbl;

SELECT col1, IF(col1=test_fc(1), 'one', 'other') FROM tbl;
SELECT col1, IF(col1=1, test_fc2(1), test_fc2(1.234)) FROM tbl;

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP TABLE IF EXISTS tbl;
