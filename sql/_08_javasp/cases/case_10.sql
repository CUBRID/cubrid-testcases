autocommit off;



create  procedure test_int10(i int)
AS language java name 'SpTest.testInt(int) return int';

drop procedure  test_int10;

create  procedure test_int10(i int, j string)
as language java name 'SpTest.testInt(int, java.lang.String) return int';   



drop procedure test_int10;

create  function test_int10(i int)
as language java name 'SpTest.testInt(int) return int';

drop function test_int10;

create function test_int10(i int, j string)
as language java name 'SpTest.testInt(int, java.lang.String) return int';

drop function test_int10;

create procedure test_int10(i int, j string) return int
as language java name 'SpTest.testInt(int, java.lang.String) return int ';

create procedure test_int10(i int, j string) return int
as language java name 'SpTest.testInt(int, java.lang.String)  ';

drop procedure test_int10;

rollback;

autocommit on;


