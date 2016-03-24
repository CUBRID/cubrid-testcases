--+ holdcas on;

CREATE   Procedure  ptestdate1(i in out date) as language java name 'SpTest5.ptestdate2(java.sql.Date[]) ';
$varchar,$2000/12/28;
call ptestdate1(?) ;
$varchar,$2000:12:29;
call ptestdate1(?) ;
$varchar,$2000-10-20;
call ptestdate1(?) ;
drop procedure ptestdate1;

CREATE   Procedure  testInt(i int) as language java name 'SpTest.testInt(int) ';
call  testint(1);
call  testint(1.11112);
$integer,$1;
call testint(?) ;
call test1();
call test1('x');
drop procedure testInt;

CREATE   function  testInt(i int) return int as language java name 'SpTest.testInt(int) ';
call  testint(1);
call  testint(1.11112);
$integer,$1;
call testint(?) ;
$double,$1;
call testint(?) ;
call test1();
call test1('x');
drop function testInt;

 CREATE  FUNCTION jdbc1(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';
 CREATE  procedure  jdbc2(i string)  as language java name 'jdbc_cubrid415.main2(java.lang.String) ';
 CREATE  procedure  jdbc3_c(i string)  as language java name 'jdbc_cubrid415.main3_c(java.lang.String) ';
 CREATE  procedure  jdbc3_r(i string)  as language java name 'jdbc_cubrid415.main3_r(java.lang.String) ';
 CREATE  procedure  jdbc3_autocommiton(i string)  as language java name 'jdbc_cubrid415.main3_autocommiton(java.lang.String) ';

call jdbc2('create class yoo');
select * from yoo;

call jdbc3_c('create class zoo');
select * from zoo;

call jdbc2('call jdbc3_c(''create class xoo ( id int)'')');
select * from xoo;

call jdbc2('insert into xoo values(10)');
call jdbc3_c('insert into xoo values(20)');
call jdbc3_r('insert into xoo values(30)');
call jdbc3_autocommiton('insert into xoo values(40)');

select * from xoo;

--+ holdcas on;

drop function jdbc1;
drop procedure jdbc2;
drop procedure jdbc3_c;
drop procedure jdbc3_r;
drop procedure jdbc3_autocommiton;
drop yoo;
drop zoo;

commit;

--+ holdcas off;

