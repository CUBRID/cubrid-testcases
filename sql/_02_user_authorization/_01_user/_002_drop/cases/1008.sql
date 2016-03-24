--+ holdcas on;
-- create user by dba and retrieve db_user system class and then drop it
call login('dba','') on class db_user;
create user user1 password 'a';
SELECT * FROM db_user WHERE NAME = 'user1';
DROP USER user1;

--+ holdcas off;
