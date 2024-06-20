autocommit off;


CREATE function  test7(i int) return string as language java name 'SpTest4.returnnull(int)  return java.lang.String ';
call test7(1);
select test7(1) from db_root;
drop function test7;

CREATE function  test7(i int) return int as language java name 'SpTest4.returnnull(int)  return java.lang.String ';
call test7(1);
select test7(1) from db_root;
drop function test7;



CREATE function  test8(i int) return string as language java name 'SpTest4.returnempty(int)  return java.lang.String ';
call test8(1);
select test8(1) from db_root;
drop function test8;

CREATE function  test8(i int) return int as language java name 'SpTest4.returnempty(int)  return java.lang.String ';
call test8(1);
select test8(1) from db_root;
drop function test8;


CREATE function  test1() return int as language java name 'SpTest4.exittest() return int' ;
call test1();
select test1() from db_root;
drop function test1;


CREATE procedure  test2(x inout string) as language java name 'SpTest4.main(java.lang.String[]) return int' ;
call test2('xxx');
select test2('xxx') from db_root;
drop procedure test2;


CREATE procedure  test3() as language java name 'SpTest4.SpTest4()' ;
call test3('xxx');
select test3('xxx') from db_root;
call test3();
select test3() from db_root;
drop procedure test3;



CREATE procedure  test5() as language java name 'SpTest4.dividebyzero1()' ;
CREATE procedure  test6() as language java name 'SpTest4.dividebyzero2()' ;
call test5();
call test6();
select test5() from db_root;
select test6() from db_root;
drop procedure test5;
drop procedure test6;






rollback;
autocommit on;

