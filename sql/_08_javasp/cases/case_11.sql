autocommit off;



create procedure test_int11(i int) return int
as language java name 'SpTest.testInt(int) return int'; 
-- fail


rollback;
autocommit on;

