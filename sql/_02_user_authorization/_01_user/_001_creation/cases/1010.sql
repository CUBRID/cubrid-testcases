--+ holdcas on;
--Create user and set password by call method
call login('dba','') on class db_user;
call add_user('test_user','passwd') on class _db_user;
call drop_user('test_user') on class _db_user; 

--+ holdcas off;
