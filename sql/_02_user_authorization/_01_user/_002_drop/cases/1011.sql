--+ holdcas on;
-- drop user by drop_user function
call login('dba','') on class db_user;


CALL add_user('user1') on class db_user;


call DROP_user('user1') ON CLASS db_user;


--+ holdcas off;
