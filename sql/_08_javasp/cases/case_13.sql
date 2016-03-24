autocommit off;

create function test_int14(i number, j number) return number            
as language java name 'SpTest.testInt(int,int) return int';



create function test_int15(i number, j string) return number 
as language java name 'SpTest.testInt(int,java.lang.String) return int';



$out:integer,$NULL;
? = call test_int14(2,3) ;
$out:integer,$NULL;
? = call test_int14(2.3,6.6) ;
$out:integer,$NULL;
? = call test_int14(1,2) ;
$out:integer,$NULL;
? = call test_int14('3','3') ;

$out:integer,$NULL;
? = call test_int15(1,'1') ;
$out:integer,$NULL;
? = call test_int15(1,'2',3) ;


rollback;
autocommit on;

