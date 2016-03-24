--+ holdcas on;

--fail
create function test_int6(i number)
as language java name 'SpTest.testInt(int) return int'; 

commit;
--+ holdcas off;

