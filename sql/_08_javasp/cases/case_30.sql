autocommit off;



create  procedure test_int10(i int)
is language java name 'SpTest.testInt(int) return int';

create  procedure test_int10(i int)
as language java name 'SpTest.testInt(int) return int';

drop function test_int10;




rollback;
autocommit on;

