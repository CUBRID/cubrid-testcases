--TC01: Check whether default value is expanding
--      properly by INSERT statement
--
-- Notice:
--   This is CBRD-20399 enhancement.
--   So, apply this test case to former CUBRID
--   will lead to verdict 'fail'
--
DROP CLASS IF EXISTS test01;
--
CREATE TABLE test01 (
	col1 INT PRIMARY KEY AUTO_INCREMENT,
	col2 VARCHAR(19) DEFAULT TO_CHAR(SYSDATETIME, 'YYYYMMDD-HH24MISS-FF'),
	col3 VARCHAR(19)
);

-- INSERT DATA
INSERT INTO test01 (col3) VALUES(TO_CHAR(SYSDATETIME, 'YYYYMMDD-HH24MISS-FF'));

-- Select DATA & Compare values
-- col2: by default
-- col3: by insert statement
SELECT IF(col2 = col3, 'OK', 'NOK') FROM test01;

-- DROP TABLE
DROP TABLE test01;
