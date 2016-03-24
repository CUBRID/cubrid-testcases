autocommit off;




 CREATE  FUNCTION test_double(d double) RETURN double AS LANGUAGE JAVA NAME 'SpTest.testDouble(double) return double';

  CREATE   FUNCTION test_double_1(d double) RETURN float AS LANGUAGE JAVA NAME 'SpTest.testDouble(double) return float';

  CREATE   FUNCTION test_float(c float) RETURN float AS LANGUAGE JAVA NAME 'SpTest.testFloat(float) return float';


$out:double,$NULL;
? = call test_double( 1.1234 ) ;
$out:double,$NULL;
? = call test_double( 3.333 ) ;

$out:double,$NULL;
? = call test_double( 5 ) ;
$out:double,$NULL;
? = call test_double( cast ( 55555 as float)) ;

$out:double,$NULL;
? = call test_double_1(5.555) ;

$out:double,$NULL,$double,$5.555;
? = call test_float( ? ) ;

$out:double,$NULL,$integer,$5555;
? = call test_float( ? ) ;

$out:double,$NULL,$double,$5555;
? = call test_float( ? ) ;

rollback;


autocommit on;

