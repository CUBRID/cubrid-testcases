--+ holdcas on;

autocommit off;

CREATE procedure test2(x inout string) as language java name 'SpTest5.ptestint2(int []) return int' ; 
call test2(1);
select 100 into x from db_root;
call test2(x);
call test2(10+10);
drop procedure test2;

CREATE procedure test2(x out string) as language java name 'SpTest5.ptestint2(int []) return int' ; 
call test2(1);
select 100 into x from db_root;
call test2(x);
call test2(10+10);
drop procedure test2;

CREATE  Procedure  ptestint1(i in out int) as language java name 'SpTest5.ptestint1(int) ';
call ptestint1((select 10 from db_root));
drop procedure ptestint1;

CREATE  Procedure  ptestint1(i in out int) as language java name 'SpTest5.ptestint1(int) ';

select 10 into x from db_root;
call ptestint1(x);
call ptestint1(10);
call ptestint1((select 10 from db_root));
$integer,$10;
call ptestint1(?) ;


CREATE FUNCTION typetestinteger20() RETURN string as language java name 'SpTest3.typetestinteger2() return java.lang.Integer'; 
CREATE FUNCTION typetestinteger30() RETURN string as language java name 'SpTest3.typetestinteger3() return java.lang.Integer'; 


CREATE procedure test2(x inout string) as language java name 'SpTest4.main(java.lang.String[]) return int' ; 
call test2('xxx'); 

CREATE procedure test3() as language java name 'SpTest4.SpTest4()' ; 
call test3('xxx'); 

CREATE procedure test4() as language java name 'SpTest4.throwexception()' ; 
call test4(); 

CREATE procedure test5() as language java name 'SpTest4.dividebyzero1()' ; 
CREATE procedure test6() as language java name 'SpTest4.dividebyzero2()' ; 
call test5(); 
call test6(); 

rollback;

autocommit on;


--+ holdcas off;
