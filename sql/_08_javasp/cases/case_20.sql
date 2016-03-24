autocommit off;


CREATE  FUNCTION test_date(d date) RETURN date
AS LANGUAGE JAVA NAME 'SpTest.testDate(java.sql.Date) return java.sql.Date';


$out:date,$NULL;
? = call test_date('2004-02-01') ;

$out:varchar,$NULL,$date,$20040101;
? = call test_date(?) ;

$out:date,$NULL;
? = call test_date('2004-02-01 AM 10:10:10') ;

drop function test_date;

rollback;
autocommit on;

