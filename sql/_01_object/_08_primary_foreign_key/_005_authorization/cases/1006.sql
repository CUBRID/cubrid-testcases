--+ holdcas on;
-- [er]create user by dba as existing username
call login('dba','') on class db_user;
create user user1 password 'a';
create user user1 password 'a';

DROP USER user1;

--+ holdcas off;
