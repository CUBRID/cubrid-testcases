autocommit off;

 CREATE  FUNCTION jdbc1(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';
 CREATE  procedure  jdbc2(i string)  as language java name 'jdbc_cubrid415.main2(java.lang.String) ';
 CREATE  procedure  jdbc3_c(i string)  as language java name 'jdbc_cubrid415.main3_c(java.lang.String) ';
 CREATE  procedure  jdbc3_r(i string)  as language java name 'jdbc_cubrid415.main3_r(java.lang.String) ';
 CREATE  procedure  jdbc_autocommiton(i string)  as language java name 'jdbc_cubrid415.main3_autocommiton(java.lang.String) ';


call jdbc3_c('create class xoo');
rollback;
select * from xoo;

autocommit on;





