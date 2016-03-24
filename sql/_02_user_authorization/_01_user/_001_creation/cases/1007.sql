--+ holdcas on;
-- create user by add_user function
call login('dba','') on class db_user;


CALL add_user('user1') on class db_user;


drop user user1;

--+ holdcas off;
