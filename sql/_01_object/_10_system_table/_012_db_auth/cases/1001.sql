--+ holdcas on;
--Test the db_auth's 'grantor_name' attribute


call login('dba') on class db_user;
create class test_class(col1 integer, col2 varchar(10));
create user test_user;
create user test_user1;
grant select on test_class to test_user;
grant alter on test_class to test_user1;

select grantor_name, grantee_name, class_name from db_auth
where  grantor_name ='DBA' and class_name is not null and grantee_name is not null order by 1,2,3;

drop user test_user1;
drop user test_user;
drop class test_class;

--+ holdcas off;
