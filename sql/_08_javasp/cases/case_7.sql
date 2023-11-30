autocommit on;

create procedure test_int7(i int) 
as language java name 'SpTest.testInt_1(int) return int';

drop procedure test_int7;

create  procedure test_int7(i int) 
as language java name 'SpTest.testInt_1(int) ';

drop procedure test_int7;

$integer,$5;
call test_int7(?) ;
$integer,$8;
call test_int7(?) ;
$integer,$100;
call test_int7(?, '1') ;

drop procedure test_int7;

create  procedure test_int7(i  in out int) 
as language java name 'SpTest.testInt_3(int []) ';

$integer,$5;
call test_int7(?) ;
$integer,$8;
call test_int7(?) ;
$integer,$100;
call test_int7(?, '1') ;

drop procedure test_int7;

rollback;

autocommit on;

