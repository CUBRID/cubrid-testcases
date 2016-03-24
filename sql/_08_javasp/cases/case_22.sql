autocommit off;

 CREATE FUNCTION test_timestamp(d timestamp) RETURN timestamp AS LANGUAGE JAVA NAME 'SpTest.testTimestamp(java.sql.Timestamp) return java.sql.Timestamp';



$out:timestamp,$NULL;
? = call test_timestamp(timestamp'5/5/2005 1:1:1 am') ;
$out:timestamp,$NULL;
? = call test_timestamp(timestamp'5/6/2005 1:1:1 am') ;

drop function test_timestamp;

rollback;
autocommit on;

