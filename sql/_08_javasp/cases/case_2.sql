autocommit on;

create function test_int2(i int) return int
as language java name 'SpTest.testInt(int) return int';

drop function test_int2;

create  function test_int2(i int) return int
as language java name 'SpTest.testInt(int) return int';

drop function test_int2;

rollback;

autocommit on;



