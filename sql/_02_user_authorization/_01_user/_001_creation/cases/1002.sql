--+ holdcas on;
-- [er]create user by public 
call login('public','') on class db_user;
create user user1 password 'a';
DROP USER user1;
call login('dba', '') on class db_user;

--+ holdcas off;
