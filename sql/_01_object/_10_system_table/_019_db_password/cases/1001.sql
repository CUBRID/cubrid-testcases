--+ holdcas on;
--Test system table db_password
call login('dba') on class db_user;
create user test_user password 'passwd' groups dba;

drop user test_user;
--+ holdcas off;
