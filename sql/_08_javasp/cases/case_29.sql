autocommit off;

create function test_int4(i int, j string) return int
is language java name 'SpTest.testInt(int,java.lang.String) return int';  

drop function test_int4;

create  function Test_Int4(i int, j string) return int
is language java name 'SpTest.testInt(int,java.lang.String) return int';  
-- �ߺ�����



drop function test_int4;


rollback;

autocommit on;

