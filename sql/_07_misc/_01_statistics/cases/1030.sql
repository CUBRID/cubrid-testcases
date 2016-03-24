--+ holdcas on;
--Test update statistics by common user
call login('dba') on class db_user;
call add_user('test_user') on class db_user;
call login('test_user') on class db_user;

update statistics on all classes;

call login('dba') on class db_user;
call drop_user('test_user') on class db_user;
--+ holdcas off;
