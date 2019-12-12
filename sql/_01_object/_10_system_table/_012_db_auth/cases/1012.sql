--+ holdcas on;
--[er]Some filed is case-sensitive:GRANTOR_NAME
call login('dba') on class db_user;
create class test_class(col1 integer, col2 varchar(10));
create user test_user;
create user test_user1;
grant select on test_class to test_user;
grant alter on test_class to test_user1;

--Can't query any record
select grantor_name, grantee_name, class_name from db_auth
where  grantor_name ='dba';

drop user test_user1;
drop user test_user;
drop class test_class;

--+ holdcas off;
