autocommit off;

CREATE  FUNCTION test_float(f float) RETURN number
AS LANGUAGE JAVA NAME 'SpTest.testFloat(float) return float';


$out:float,$NULL;
? =  call test_float(cast ( 66666 as float) ) ;
$out:float,$NULL;
? =call test_float(6.6666 ) ;
$out:integer,$NULL,$float,$6.66666;
? = call test_float(?) ;
$out:float,$NULL;
? = call test_float(6) ;

rollback;

autocommit on;

