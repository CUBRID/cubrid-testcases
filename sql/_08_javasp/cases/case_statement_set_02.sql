--This is a test case to verify the use of character set operators with javasp functions. (UNION ALL)

DROP TABLE IF EXISTS test_tbl;

CREATE OR REPLACE FUNCTION test_fc(i string) RETURN int as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE OR REPLACE FUNCTION test_fc2(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';

CREATE TABLE test_tbl(col1 varchar(200), col2 int);
INSERT INTO test_tbl VALUES ('1', 1);
INSERT INTO test_tbl VALUES ('2', 1);

SELECT test_fc(col1) FROM test_tbl
UNION ALL SELECT test_fc2(col2) FROM test_tbl;

CREATE OR REPLACE FUNCTION test_date(d date) RETURN date AS LANGUAGE JAVA NAME 'SpTest.testDate(java.sql.Date) return java.sql.Date';
CREATE OR REPLACE FUNCTION test_time(d time) RETURN time AS LANGUAGE JAVA NAME 'SpTest.testTime(java.sql.Time) return java.sql.Time';
CREATE OR REPLACE FUNCTION test_timestamp(d timestamp) RETURN timestamp AS LANGUAGE JAVA NAME 'SpTest.testTimestamp(java.sql.Timestamp) return java.sql.Timestamp';

--fail (time - timestamp) (Cannot coerce time to type timestamp)
SELECT test_time(time'12:00:00 AM')
UNION ALL SELECT test_timestamp(timestamp'5/5/2005 12:00:00 am');

--success (timestamp - time)
SELECT test_time(timestamp'5/5/2005 12:00:00 AM') 
UNION ALL SELECT test_time(time'13:01:01 PM');

--success (date - timestamp)
SELECT test_date(date'2023-02-28')
UNION ALL SELECT test_timestamp(timestamp'2022-06-30 19:30:13 pm');

--success (timestamp - date)
SELECT test_timestamp(timestamp'2022-05-05 12:00:00 am') 
UNION ALL SELECT test_date('2022-05-05');

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP FUNCTION test_time;
DROP FUNCTION test_date;
DROP FUNCTION test_timestamp;
DROP TABLE IF EXISTS test_tbl;
