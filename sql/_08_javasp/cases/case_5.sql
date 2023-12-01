autocommit off;

create  function test_int5(i int) return int
as language java name 'SpTest.testInt_1(int) return int';

$out:integer,$NULL;
? = call test_int5(1000) ;

drop function test_int5;

rollback;

autocommit on;


