--+ holdcas on;
autocommit off;

CREATE  FUNCTION test_int1(i int) RETURN int
as language java name 'SpTest.testInt(int) return int';

$out:integer,$NULL;
? = call test_int1(1) ;
select 100 into x from db_root;
call test_int1(x);
call test_int1(100);
call test_int1('100');
call test_int1(1,2);
call test_int1(1,'2');
call test_int1(1,2,4);
$out:integer,$NULL,$integer,$10;
? = call test_int1(?) ;
$out:integer,$NULL;
? = call test_int1(1) ;
$out:integer,$NULL;
? = call test_int1(1,2) ;
$out:integer,$NULL;
? = call test_int1(1,'2') ;
$out:integer,$NULL;
? = call test_int1(1,4.3) ;


 FUNCTION test_int1() RETURN int
as language java name 'SpTest.testInt() return int';

call test_int1();

rollback;

autocommit on;


--+ holdcas off;
