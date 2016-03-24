--+ holdcas on;
--Test system table db_password bu creating multiuser;
call login('dba') on class db_user;
create user test_user password 'passwd';
call add_user('test_user1') on class db_user to arg_user;
call set_password('passwd') on arg_user;

drop user test_user;
drop user test_user1;
--+ holdcas off;
