autocommit off;

create function test_int19(i int, j int) return string
is language java name 'SpTest.testInt_2(int, int) return java.lang.String';  
--   string ¹ÝÈ¯


$out:varchar,$NULL;
? = call test_int19(4,4) ;
$out:integer,$NULL,$varchar,$10;
? = call test_int19(?,4) ;

rollback;
autocommit on;

