--This is a test case to test whether the javasp function supports the SQL-Comparison function

DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl(col1 INT, col2 INT, col3 INT);
INSERT INTO tbl(col1) VALUES (1),(2),(3);
CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION test_fc2(i double) RETURN double as language java name 'SpTest7.typetestdouble1(double) return double';
CREATE FUNCTION test_fc3(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';

SELECT col1, DECODE(col1,test_fc(1),'1',test_fc(2),'2',test_fc(3),'3') FROM tbl;
SELECT col1, DECODE(col1, 1, test_fc(1), 2, test_fc2(1.2), test_fc2(1.234)) FROM tbl;
SELECT col1, DECODE(col1, 1, test_fc(1), 2, test_fc2(1.2), test_fc(1.234)) FROM tbl;
SELECT col1, DECODE(col1,test_fc(1),'one',test_fc(2),'two',test_fc(3),'three') FROM tbl;
SELECT col1, DECODE(col1,1,test_fc3('select col1 from tbl'),2,test_fc3('select col2 from tbl'),test_fc(3),'three') FROM tbl;

SELECT col1, IF(col1=test_fc(1), 'one', 'other') FROM tbl;
SELECT col1, IF(col1=1, test_fc2(1), test_fc2(1.234)) FROM tbl;
SELECT col1, IF(col1=1, test_fc3('select count(*) from tbl'), test_fc3('select col1 from tbl where col1=1')) FROM tbl;

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP FUNCTION test_fc3;
DROP TABLE IF EXISTS tbl;
