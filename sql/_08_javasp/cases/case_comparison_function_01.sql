--This is a test case to test whether the javasp function supports the SQL-Comparison function

DROP TABLE IF EXISTS test_tbl;

CREATE TABLE test_tbl(col1 INT, col2 INT, col3 INT);
INSERT INTO test_tbl(col1) VALUES (1),(2),(3);
CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION test_fc2(i double) RETURN double as language java name 'SpTest7.typetestdouble1(double) return double';
CREATE OR REPLACE FUNCTION test_fc3(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';

SELECT col1, DECODE(test_fc(col1),test_fc(1),'1',test_fc(2),'2',test_fc(3),'3') FROM test_tbl;
SELECT col1, DECODE(test_fc(col1), 1, test_fc(1), 2, test_fc2(1.2), test_fc2(1.234)) FROM test_tbl;
SELECT col1, DECODE(test_fc(col1), 1, test_fc(1), 2, test_fc2(1.2), test_fc(1.234)) FROM test_tbl;
SELECT col1, DECODE(test_fc(col1),test_fc(1),'one',test_fc(2),'two',test_fc(3),'three') FROM test_tbl;
SELECT col1, DECODE(test_fc(col1),1,test_fc3('select col1 from test_tbl'),2,test_fc3('select col2 from test_tbl'),test_fc(3),'three') FROM test_tbl;

SELECT col1, 
	CASE WHEN test_fc(col1)=test_fc(1) THEN '1' 
	     WHEN test_fc(col1)=test_fc(2) THEN '2'
	     ELSE '3'
	END
FROM test_tbl;

SELECT col1, 
	CASE WHEN test_fc(col1)=1 THEN test_fc(1)
	     WHEN test_fc(col1)=2 THEN test_fc2(1.2)
	     ELSE test_fc2(1.234)
	END
FROM test_tbl;

SELECT col1,
        CASE WHEN test_fc(col1)=1 THEN test_fc(1)
             WHEN test_fc(col1)=2 THEN test_fc2(1.2)
             ELSE test_fc(1.234)
        END
FROM test_tbl;

SELECT col1,
        CASE WHEN test_fc(col1)=test_fc(1) THEN 'one'
             WHEN test_fc(col1)=test_fc(2) THEN 'two'
             ELSE 'three'
        END
FROM test_tbl;

SELECT col1,
        CASE WHEN test_fc(col1)=1 THEN test_fc3('select col1 from test_tbl')
             WHEN test_fc(col1)=2 THEN test_fc3('select col2 from test_tbl')
             ELSE 'three'
        END
FROM test_tbl;

SELECT col1, IF(test_fc(col1)=test_fc(1), 'one', 'other') FROM test_tbl;
SELECT col1, IF(test_fc(col1)=1, test_fc2(1), test_fc2(1.234)) FROM test_tbl;
SELECT col1, IF(test_fc(col1)=1, test_fc3('select count(*) from test_tbl'), test_fc3('select col1 from test_tbl where col1=1')) FROM test_tbl;

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP FUNCTION test_fc3;
DROP TABLE IF EXISTS test_tbl;
