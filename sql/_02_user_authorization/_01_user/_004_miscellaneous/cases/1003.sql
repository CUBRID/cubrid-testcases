--+ holdcas on;
--Test login(), add_user(), drop_user() methods
call login('dba') on class db_user;
call add_user('test_user') on class db_user;
call drop_user('test_user') on class db_user;
--+ holdcas off;
