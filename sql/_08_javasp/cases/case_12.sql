autocommit off;

create function test_int12(i int, j float , c string ) return int 
as language java name 'SpTest.testInt(int,float,java.lang.String) return int';


$out:integer,$NULL;
? = call test_int12(1,  3.3456 ,'5')  ;

$out:integer,$NULL;
? = call test_int12(1, cast(33456 as float) ,'5')  ;

$out:integer,$NULL;
? = call test_int12(1, cast(3.3456 as float) ,'5')  ;

$out:integer,$NULL,$float,$8.3456;
? = call test_int12(1, ? ,'5') ;

$out:integer,$NULL,$integer,$1;
? = call test_int12(?,cast( 3456 as float),'5') ;

$out:integer,$NULL;
? = call test_int12(1, cast( 36 as float),'5')  ;

rollback;

autocommit on;

