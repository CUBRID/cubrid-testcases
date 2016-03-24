autocommit_on;


 CREATE  procedure  jdbc2(i string)  as language java name 'jdbc_cubrid415.main2(java.lang.String) ';
 CREATE  procedure  jdbc3_c(i string)  as language java name 'jdbc_cubrid415.main3_c(java.lang.String) ';
 CREATE  procedure  jdbc3_r(i string)  as language java name 'jdbc_cubrid415.main3_r(java.lang.String) ';
 CREATE  procedure  jdbc3_autocommiton(i string)  as language java name 'jdbc_cubrid415.main3_autocommiton(java.lang.String) ';
CREATE  FUNCTION jdbc1(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';

call jdbc1('call jdbc2(''create class xoo ( id int)'')');
call jdbc2('insert into xoo values(10)');
call jdbc3_c('insert into xoo values(20)');
call jdbc3_r('insert into xoo values(30)');
call jdbc3_autocommiton('insert into xoo values(40)');
call jdbc1('select * from xoo');
select * from xoo;

call jdbc1('call jdbc2(''create class yoo (a string)'')');
call jdbc2('insert into yoo values(''abbbb'')');
call jdbc3_c('insert into yoo values(''abcd'')');
call jdbc3_r('insert into yoo values(''1234'')');
call jdbc3_autocommiton('insert into yoo values(''dfdfbcd1234'')');
call jdbc1('select * from yoo');
select * from yoo;

create class zoo ( id string);
insert into zoo values('dfdf');
insert into zoo values('abcd');
insert into zoo values('1234');
insert into zoo values('dfdfdf');

select * from zoo;
call jdbc1('select * from zoo');







drop xoo, yoo, zoo;               

create class xoo ( id string);
insert into xoo values('dfdf');
insert into xoo values('abcd');
insert into xoo values('1234');
insert into xoo values('dfdfdf');

call jdbc1('select * from xoo');
select * from xoo;

drop xoo;
drop FUNCTION jdbc1;
drop procedure  jdbc2    ;
drop procedure  jdbc3_c;
drop procedure  jdbc3_r;
drop procedure  jdbc3_autocommiton;

commit;

autocommit on;

