--+ holdcas on;
-- drop user by drop_user function
call login('dba','') on class db_user;


CALL add_user('user1') on class _db_user;


call DROP_user('user1') on class _db_user;


--+ holdcas off;
