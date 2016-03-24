--+ holdcas on;

call login('dba', '') on class db_user;
call add_user('test_user') on class db_user;
call change_owner('db_class', 'test_user') on class db_authorizations;
call change_owner('db_user', 'test_user') on class db_authorizations;
call change_owner('db_authorizations', 'test_user') on class db_authorizations;
call change_owner('db_index', 'test_user') on class db_authorizations;
call login('test_user', '') on class db_user;
select class_name from db_class order by class_name; 
call login('dba', '') on class db_user;
call drop_user('test_user') on class db_user;

call login('dba', '') on class db_user;
call add_user('test_user1') on class db_user;
alter view db_class owner to test_user1;
alter class db_user owner to test_user1;
alter class db_authorizations owner to test_user1;
alter view db_index owner to test_user1;
call login('test_user1', '') on class db_user;
select class_name from db_class order by class_name; 
call login('dba', '') on class db_user;
call drop_user('test_user1') on class db_user;

--+ holdcas off;
