--TC02: Check whether a Partitioned Table 
--     can be created with extended default.
--
-- Notice:
--   This is CBRD-20399 enhancement.
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'
--
DROP CLASS IF EXISTS t02;
--
create table T02 (
col1 int PRIMARY KEY AUTO_INCREMENT,
col2 float default 3.215,
col3 char(14) default to_char(sysdatetime, 'YYYYMMDDHH24MISS'),
col4 int default 0,
col5 varchar(14))
partition by hash(col1) partitions 8;

-- INSERT DATA
INSERT INTO T02 (col5) VALUES(TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));

-- COMPARE RESULT
SELECT IF(col3 = col5, 'OK', 'NOK') FROM T02;

DROP TABLE T02;
