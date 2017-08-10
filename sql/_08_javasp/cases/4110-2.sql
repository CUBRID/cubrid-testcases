
autocommit off;

CREATE FUNCTION jdbc1(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String'; 

create class jdbc1(id int); 
insert into jdbc1 values(100000); 
select * from jdbc1; 
call jdbc1('select * from jdbc1'); 

drop function jdbc1;

 CREATE  FUNCTION jdbc1(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';


 call jdbc1('select name,id,password from db_user order by 1') ;
 call jdbc1('select name,id,password from db_user ','') ;
$varchar,$select * from db_user;
  call jdbc1(?) ;

rollback;

autocommit on;

