--+ holdcas on;
--[er]Test change_owner() methods to change system table,then new user cannot access the system table
call login('dba') on class db_user;
call add_user('test_user') on class db_user;


call change_owner('db_class', 'test_user') on class db_authorizations;
call login('test_user') on class db_user;
select * from db_class;
call login('dba') on class db_user;
call change_owner('db_class', 'dba') on class db_authorizations;
select * from db_class order by 1;

call drop_user('test_user') on class db_user;


--+ holdcas off;
