--+ holdcas on;
--Create mutliuser with same password

call login('dba') on class db_user;
create user test_user password '密码';
call add_user('test_user1') on class db_user to arg_user;
call set_password('密码') on arg_user;


drop user test_user;
drop user test_user1;
--+ holdcas off;
