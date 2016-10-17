--TC06: ALTER/SET Default to extended Default
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
col3 varchar(14),
col4 varchar(14),
PRIMARY KEY(col1));

--
-- ALTER/ADD New Column
alter table test01 alter column col4 set default to_char(sysdatetime, 'YYYYMMDDHH24MISS');
--
-- INSERT with New Default
INSERT INTO test01 (col1, col3) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));

SELECT IF(col3 = col4, 'OK', 'NOK') FROM test01;
--
--
DROP TABLE TEST01;

