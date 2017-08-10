--+ holdcas on;
-- create user by dba as existing class name and then drop it
call login('dba','') on class db_user;
create CLASS user1 (a INT);
create user user1 password 'a';
DROP USER user1;
drop class user1;

--+ holdcas off;
