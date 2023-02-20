--This is a test case to test the operation of setting the initial value with the result value of the javasp function by using Default when creating a table.

DROP TABLE IF EXISTS test_tbl;
DROP TABLE IF EXISTS test_tbl2;
DROP TABLE IF EXISTS test_tbl3;

--(with parameters) success.
CREATE OR REPLACE FUNCTION test_fc(i int) RETURN string as language java name 'SpTest.testInt(int) return int';
CREATE TABLE test_tbl(col1 varchar(200) DEFAULT test_fc(1), col2 varchar(100)); 
INSERT INTO test_tbl(col2) VALUES('1234');
SELECT * FROM test_tbl;

--(no parameters) fail.
CREATE OR REPLACE FUNCTION test_fc2() RETURN int as language java name 'SpTest.testInt10() return int';
CREATE TABLE test_tbl2(col1 int DEFAULT test_fc2());

--javasp function using db connection. success.
CREATE FUNCTION test_fc3(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';
CREATE TABLE test_tbl3(col1 varchar(30) DEFAULT test_fc3('select * from test_tbl'), col2 int);
INSERT INTO test_tbl3(col2) VALUES(1);
SELECT * FROM test_tbl3;

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP FUNCTION test_fc3;
DROP TABLE IF EXISTS test_tbl;
DROP TABLE IF EXISTS test_tbl2;
DROP TABLE IF EXISTS test_tbl3;
