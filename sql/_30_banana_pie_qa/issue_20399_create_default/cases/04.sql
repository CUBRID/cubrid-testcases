--TC04: CREATE TABLE USING 'CREATE AS'
--      with extended default
--
-- Notice:
--   This is CBRD-20399 enhancement.
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'
--
DROP TABLE IF EXISTS test01;
--
create table test01 (
col1 int,
col2 float DEFAULT 3.215,
col3 char(14) DEFAULT to_char(sysdatetime, 'YYYYMMDDHH24MISS'),
col4 int DEFAULT 0,
col5 varchar(14),
PRIMARY KEY(col1));
--
-- INSERT DATA
INSERT INTO test01 (col1, col5) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));
--
DROP TABLE IF EXISTS test03;
-- create using LIKE,
CREATE TABLE test03 AS SELECT * FROM test01;
--
-- count MUST be 1
SELECT COUNT(*) FROM TEST03;

-- Check INSERTED from Table 'test01'
SELECT IF(col3 = col5, 'OK', 'NOK') FROM test03;
--
TRUNCATE TABLE TEST03;
INSERT INTO test03 (col1, col5) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));
SELECT IF(col3 = col5, 'OK', 'NOK') FROM test03;
--
DROP TABLE TEST01;
DROP TABLE TEST03;
