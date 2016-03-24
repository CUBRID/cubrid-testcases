--+ holdcas on;
--create new user and retrieve information from db_user
call login('dba','') on class db_user;
create user user1 password 'a';
select * from db_user
where name = 'USER1';
DROP USER user1;

--+ holdcas off;
