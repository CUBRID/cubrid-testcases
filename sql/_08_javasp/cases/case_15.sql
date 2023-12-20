--+ holdcas on;

create function test_int16(i int, j string) return int 
as language java name 'SpTest.testInt(int,java.lang.string) return int';  
-- java_type_full name  

create function test_int17(i int, j string) return int 
as language java name 'SpTest.testInt(int,java.lang.String) return String';  
-- java_type_full name  

$out:integer,$NULL;
? = call test_int16(2,'4') ;

drop function test_int16;
drop function test_int17;

commit;

--+ holdcas off;

