--+ holdcas on;
--Test authorization type:execute

call login('dba') on class db_user;

create user test_user;
grant execute on db_user to test_user;

call login ('test_user') on class db_user;




select grantor_name, grantee_name, 
       class_name, auth_type 
from   db_auth
where  grantee_name = 'TEST_USER' order by 1,2;

select grantor_name, grantee_name, 
       class_name, auth_type 
from   db_auth
where  auth_type='EXECUTE' and grantee_name is not null order by 1,2,3;
call login('dba') on class db_user;
drop user test_user;


--+ holdcas off;
