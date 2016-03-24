--+ holdcas on;
-- [er]drop a user whith non-existing
call login('dba','') on class db_user;
create user user1 password 'a';
DROP USER user1;
drop user user2;

call login('dba', '') on class db_user;


--+ holdcas off;
