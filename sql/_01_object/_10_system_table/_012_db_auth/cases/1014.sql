--+ holdcas on;
--[er]Some filed is case-sensitive:AUTH_TYPE

call login('dba') on class db_user;
create class test_class(col1 integer, col2 varchar(10));
create class test_class1(col1 integer, col2 varchar(10));
insert into test_class values(999, 'nhn');
insert into test_class1 values(888, 'nhnchina');

create user test_user;

grant select on test_class to test_user;
grant insert on test_class to test_user;
grant update on test_class to test_user;
grant delete on test_class to test_user;
grant alter on test_class to test_user;
grant index on test_class to test_user;
grant execute on test_class to test_user;

--Cannot query any record
select grantor_name, grantee_name, 
       class_name, auth_type 
from   db_auth
where  auth_type in ('select','insert','update','delete','alter','indes','execute');

drop user test_user;
drop class test_class;
drop class test_class1;
--+ holdcas off;
