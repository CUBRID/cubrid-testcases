--+ holdcas on;
--[er]Cannot drop a user who own a serial;
call login('dba','') on class db_user;
create user user1 password 'a';
call login('user1','a') on class db_user;

create serial s1;

call login('dba','') on class db_user;
call drop_user('user1') on class db_user;
drop serial s1;
call drop_user('user1') on class db_user;


--+ holdcas off;
