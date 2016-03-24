autocommit off;

 CREATE FUNCTION test_time(d time) RETURN time AS LANGUAGE JAVA NAME 'SpTest.testTime(java.sql.Time) return java.sql.Time';


$out:date,$NULL;
? = call test_time(timestamp'5/5/2005 1:1:1 am') ;

rollback;
autocommit on;

