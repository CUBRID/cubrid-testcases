--+ holdcas on;
-- create user by dba and then drop it
call login('dba','') on class db_user;
create user user1 password 'a';
DROP USER user1;

--+ holdcas off;
