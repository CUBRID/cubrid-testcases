autocommit on;

create function test_int2(i number) return number
as language java name 'SpTest.testInt(int) return int';

drop function test_int2;

create  function test_int2(i number) return number
as language java name 'SpTest.testInt(int) return int';

drop function test_int2;

rollback;

autocommit on;



