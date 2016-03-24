--+ holdcas on;
--Create user and set password by call method
call login('dba','') on class db_user;
call add_user('test_user') on class db_user;
call find_user('test_user') on class db_user to user_arg;
call set_password('passwd') on user_arg;
call drop_user('test_user') on class db_user; 

--+ holdcas off;
