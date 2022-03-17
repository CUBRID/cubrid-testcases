--Test system table db_user's method:set_password()
--+ holdcas on;
call login('dba') on class db_user;
call add_user('test_user') on class db_user;
call find_user('test_user') on class db_user to arg_user;

call set_password('password') on arg_user;
call login('test_user','password') on class db_user;
call login('dba') on class db_user;
call drop_user('test_user') on class db_user;
commit;
--+ holdcas off;
