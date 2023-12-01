autocommit on;

create function test_int17(i int, j string) return int
is language java name 'SpTest.testInt(int,int) return int';  

$out:integer,$NULL;
? = call test_int17(4,4) ;

drop function test_int17;

