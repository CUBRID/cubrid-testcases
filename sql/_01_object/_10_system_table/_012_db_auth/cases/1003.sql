--+ holdcas on;
--Test the db_auth's 'class_name' attribute

call login('dba') on class db_user;
create class test_class(col1 integer, col2 varchar(10));
create class test_class1(col1 integer, col2 varchar(10));
create user test_user;
grant select on test_class to test_user;
grant alter on test_class1 to test_user;

select grantor_name, grantee_name, object_name, auth_type from db_auth
where object_name in ('test_class', 'test_class1') order by 3;

drop user test_user;
drop class test_class;
drop class test_class1;

--+ holdcas off;
