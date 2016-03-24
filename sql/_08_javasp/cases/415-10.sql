--+ holdcas on;

 CREATE  FUNCTION jdbc1(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';
 CREATE  procedure  jdbc2(i string)  as language java name 'jdbc_cubrid415.main2(java.lang.String) ';
 CREATE  procedure  jdbc3_c(i string)  as language java name 'jdbc_cubrid415.main3_c(java.lang.String) ';
 CREATE  procedure  jdbc3_r(i string)  as language java name 'jdbc_cubrid415.main3_r(java.lang.String) ';
 CREATE  procedure  jdbc3_autocommiton(i string)  as language java name 'jdbc_cubrid415.main3_autocommiton(java.lang.String) ';

call jdbc2('call jdbc3(''create class xoo ( id int)'')');
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

commit;

--+ holdcas off;

