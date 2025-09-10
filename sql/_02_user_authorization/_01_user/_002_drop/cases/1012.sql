--+ holdcas on;
-- create user by dba and retrieve db_user system class and then drop it
call login('dba','') on class db_user;
create user user1 password 'a';
select name, id, password, direct_groups, groups, authorization, triggers, is_loginable, is_system_created, comment from db_user WHERE NAME = 'USER1';
DROP USER user1;
--+ holdcas off;
