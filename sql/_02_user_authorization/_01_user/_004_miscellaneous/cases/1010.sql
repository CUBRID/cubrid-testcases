--+ holdcas on;
--Test change_owner() methods to change system table 
call login('dba') on class db_user;
call add_user('test_user') on class db_user;


call change_owner('db_class', 'test_user') on class db_authorizations;
call change_owner('db_class', 'dba') on class db_authorizations;


call drop_user('test_user') on class db_user;


--+ holdcas off;
