autocommit off;

create  function test_int8(i number) return number
as language java name 'SpTest.testInt_1(int) return int';


$out:integer,$NULL;
? = call test_int8(5) ;
$out:integer,$NULL;
? = call test_int8(10) ;
$out:integer,$NULL;
? = call test_int8(100) ;
$out:integer,$NULL;
? = call test_int8(1000) ;

drop function test_int8;

create  procedure test_int8(i in out number)
as language java name 'SpTest.testInt_3(int[])';


$integer,$1;
call test_int8(?) ;
$integer,$10;
call test_int8(?) ;
$integer,$100;
call test_int8(?) ;
$integer,$1000;
call test_int8(?) ;

drop procedure test_int8;

create  procedure test_int8(i  out number)
as language java name 'SpTest.testInt_3(int[])';


$integer,$1;
call test_int8(?) ;
$integer,$10;
call test_int8(?) ;
$integer,$100;
call test_int8(?) ;
$integer,$1000;
call test_int8(?) ;

drop procedure test_int8;

create procedure test_int8(i in out number)
as language java name 'SpTest.testInt_3(int[]) ';


$integer,$1;
call test_int8(?) ;
$integer,$10;
call test_int8(?) ;
$integer,$100;
call test_int8(?) ;
$integer,$1000;
call test_int8(?) ;
$integer,$100000;
call test_int8(?) ;

drop procedure test_int8;

rollback;

autocommit on;

