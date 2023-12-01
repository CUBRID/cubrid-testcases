autocommit off;

create  function test_int16(i int, j string) return int
is language java name 'SpTest.testInt(int,float,java.lang.String) return int';  

$out:varchar,$NULL;
? = call test_int16(1,'ss') ;

drop function test_int16;
rollback;
autocommit on;

