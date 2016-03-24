autocommit off;

create function test_int4(i number, j string) return number
is language java name 'SpTest.testInt(int,java.lang.String) return int';  

drop function test_int4;

create  function Test_Int4(i number, j string) return number
is language java name 'SpTest.testInt(int,java.lang.String) return int';  
-- 중복에러



drop function test_int4;


rollback;

autocommit on;

