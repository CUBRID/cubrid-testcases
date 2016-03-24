autocommit off;

CREATE FUNCTION test_char(c char) RETURN char AS LANGUAGE JAVA NAME 'SpTest.testChar(java.lang.String) return java.lang.String';

$out:varchar,$NULL;
? = call test_char('x') ;
$out:varchar,$NULL;
? = call test_char('xy') ;

$out:varchar,$NULL,$varchar,$xx;
? = call test_char(?) ;
$out:varchar,$NULL,$varchar,$xx;
? = call test_char(?) ;

$out:varchar,$NULL,$integer,$1000;
? = call test_char(?) ;

drop function test_char;

rollback;
autocommit on;

