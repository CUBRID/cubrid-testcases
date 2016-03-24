--+ holdcas on;
--[er]Some filed is case-sensitive:GRANTEE_NAME
call login('dba') on class db_user;
create class test_class(col1 integer, col2 varchar(10));
create class test_class1(col1 integer, col2 varchar(10));
create user test_user;
grant select on test_class to test_user;
grant alter on test_class1 to test_user;


--Can't query any record
select grantor_name, grantee_name, class_name from db_auth
where  grantee_name ='test_user';

drop user test_user;
drop class test_class;
drop class test_class1;

--+ holdcas off;
