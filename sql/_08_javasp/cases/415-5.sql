--+ holdcas on;

 CREATE  FUNCTION jdbc1(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';
 CREATE  procedure  jdbc2(i string)  as language java name 'jdbc_cubrid415.main2(java.lang.String) ';
 CREATE  procedure  jdbc3_c(i string)  as language java name 'jdbc_cubrid415.main3_c(java.lang.String) ';
 CREATE  procedure  jdbc3_r(i string)  as language java name 'jdbc_cubrid415.main3_r(java.lang.String) ';
 CREATE  procedure  jdbc_autocommiton(i string)  as language java name 'jdbc_cubrid415.main3_autocommiton(java.lang.String) ';


call jdbc_autocommiton('create class xoo');
commit;

--+ holdcas on;
select * from xoo;

drop function jdbc1;
drop procedure jdbc2;
drop procedure jdbc3_c;
drop procedure jdbc3_r;
drop procedure jdbc_autocommiton;
drop xoo;

commit;
--+ holdcas off;

