autocommit off;

create  function test_int19(i int, j int) return varchar
is language java name 'SpTest.testInt_2(int, int) return java.lang.String';  

drop function test_int19;

create  function Test_Int19(i int, j int) return varchar
is language java name 'SpTest.testInt_2(int, int) return java.lang.String';  


$out:integer,$NULL;
? = call test_int19(3,4) ;
$out:integer,$NULL;
? = call Test_Int19(4,5) ;


$out:integer,$NULL,$integer,$10;
? = call test_int19(3,?) ;
$out:integer,$NULL,$integer,$10;
? = call Test_Int19(?,5) ;

$out:integer,$NULL,$varchar,$10;
? = call Test_Int19(?,5) ;

$out:integer,$NULL,$varchar,$10;
? = call Test_Int19(?,5) ;

$out:varchar,$NULL,$varchar,$10;
? = call Test_Int19(?,5) ;

rollback;

autocommit on;


