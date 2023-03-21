--This is a test case to verify that a server-side JDBC request larger than 4096 is executed.
DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl(col1 int);
INSERT INTO tbl VALUES (1);
CREATE OR REPLACE FUNCTION sp3(i string) RETURN int as language java name 'SpTest8.SP3(java.lang.String) return int';
SELECT sp3('tbl');
DROP FUNCTION sp3;
DROP TABLE IF EXISTS tbl;
