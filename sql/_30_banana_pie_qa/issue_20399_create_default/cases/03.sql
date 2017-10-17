--TC03: CREATE TABLE USING 'CREATE LIKE'
--      with default extended default
--
-- Notice:
--   This is CBRD-20399 enhancement.
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'
--
DROP CLASS IF EXISTS test01;
create table test01 (
col1 int,
col2 float default 3.215,
col3 char(14) default to_char(sysdatetime, 'YYYYMMDDHH24MISS'),
col4 int default 0,
col5 varchar(14),
primary key(col1));
--
DROP CLASS IF EXISTS test02;
-- create using LIKE and 
-- 'test01' have extended default
create table test02 like test01;

-- INSERT DATA
INSERT INTO test02 (col1, col5) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));

-- COMPARE RESULT
SELECT IF(col3 = col5, 'OK', 'NOK') FROM test02;

DROP TABLE TEST01;
DROP TABLE TEST02;
