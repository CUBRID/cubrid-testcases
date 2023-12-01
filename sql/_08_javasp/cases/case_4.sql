autocommit off;

create  function test_int4(i int, j string) return int
is language java name 'SpTest.testInt(int,java.lang.String) return int';

$out:integer,$NULL;
? = call test_int4(1,'2') ;
$out:integer,$NULL;
? = call test_int4(1,'a') ;
$out:integer,$NULL;
? = call test_int4(1,2,'3') ;
$out:integer,$NULL;
? = call test_int4(1,'2',3) ;

rollback;
autocommit on;

