--This is a test case to verify the use of character set operators with javasp functions. (UNION, DIFFERENCE, INTERSECTION)

DROP TABLE IF EXISTS test_tbl;

CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest.testInt(int) return int';
CREATE OR REPLACE FUNCTION test_fc2(i double) RETURN double as language java name 'SpTest.testDouble(double) return double';
CREATE OR REPLACE FUNCTION test_fc3(i string) RETURN string as language java name 'SpTest.Hello(java.lang.String) return java.lang.String';

CREATE TABLE test_tbl(col1 int, col2 varchar(10));
INSERT INTO test_tbl VALUES (1, 'Cubrid');

-- int-int
SELECT test_fc(1) 
UNION SELECT test_fc(1);

SELECT test_fc(col1) from test_tbl                                                        
UNION SELECT test_fc(col1) from test_tbl;

SELECT test_fc(1) 
DIFFERENCE SELECT test_fc(1);

SELECT test_fc(col1) from test_tbl
DIFFERENCE SELECT test_fc(col1) from test_tbl;

SELECT test_fc(1) 
INTERSECTION SELECT test_fc(1);

SELECT test_fc(col1) from test_tbl
INTERSECTION SELECT test_fc(col1) from test_tbl;

-- int-double
SELECT test_fc(1)
UNION SELECT test_fc2(1);

SELECT test_fc(col1) from test_tbl
UNION SELECT test_fc2(col1) from test_tbl;

SELECT test_fc(1)
DIFFERENCE SELECT test_fc2(1);

SELECT test_fc(col1) from test_tbl
DIFFERENCE SELECT test_fc2(col1) from test_tbl;

SELECT test_fc(1)
INTERSECTION SELECT test_fc2(1);

SELECT test_fc(col1) from test_tbl
INTERSECTION SELECT test_fc2(col1) from test_tbl;

-- string-string
SELECT test_fc3('Cubrid')
UNION SELECT test_fc3('Cubrid');

SELECT test_fc3(col2) from test_tbl
UNION SELECT test_fc3(col2) from test_tbl;

SELECT test_fc3('Cubrid')
DIFFERENCE SELECT test_fc3('Cubrid');

SELECT test_fc3(col2) from test_tbl
DIFFERENCE SELECT test_fc3(col2) from test_tbl;

SELECT test_fc3('Cubrid')
INTERSECTION SELECT test_fc3('Cubrid');

SELECT test_fc3(col2) from test_tbl
INTERSECTION SELECT test_fc3(col2) from test_tbl;

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP FUNCTION test_fc3;
DROP TABLE IF EXISTS test_tbl;
