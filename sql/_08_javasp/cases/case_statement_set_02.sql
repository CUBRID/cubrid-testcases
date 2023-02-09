--This is a test case to verify the use of character set operators with javasp functions. (UNION ALL)

CREATE OR REPLACE FUNCTION test_fc(i string) RETURN int as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE OR REPLACE FUNCTION test_fc2(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';

CREATE TABLE test_tbl(col1 varchar(200), col2 int);
insert into test_tbl values ('1', 1);
insert into test_tbl values ('2', 1);

select test_fc(col1) from test_tbl
union all select test_fc2(col2) from test_tbl; --return integer  1

--The result of a UNION ALL of time and timestamp types. fail.
--ERROR: 'test_timestamp(timestamp '5/5/2005 1:1:1 am')' is not union compatible with 'test_time(timestamp '5/5/2005 1:1:1 am')'

CREATE FUNCTION test_time(d time) RETURN time AS LANGUAGE JAVA NAME 'SpTest.testTime(java.sql.Time) return java.sql.Time';
CREATE FUNCTION test_timestamp(d timestamp) RETURN timestamp AS LANGUAGE JAVA NAME 'SpTest.testTimestamp(java.sql.Timestamp) return java.sql.Timestamp';

select test_time(timestamp'5/5/2005 1:1:1 am') 
union all select test_timestamp(timestamp'5/5/2005 1:1:1 am');

drop function test_fc;
drop function test_fc2;
drop function test_time;
drop function test_timestamp;
drop table if exists test_tbl;
