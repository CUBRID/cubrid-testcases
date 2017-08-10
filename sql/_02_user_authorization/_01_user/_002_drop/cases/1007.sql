--+ holdcas on;
-- create user by dba as existing attribute name and then drop it
call login('dba','') on class db_user;
create CLASS user1 (a INT);
create user a password 'a';
DROP USER a;
drop class user1;

--+ holdcas off;
