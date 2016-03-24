autocommit off;

create function test_int3(i number)
as language java name 'SpTest.testInt(int) return int';  

rollback;
autocommit on;

