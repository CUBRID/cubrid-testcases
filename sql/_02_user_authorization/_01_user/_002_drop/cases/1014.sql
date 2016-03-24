--+ holdcas on;
--Create user and create class in the user,then drop the user
call login('dba','') on class db_user;
create user user1 password 'a';
call login('user1','a') on class db_user;

create class t1 (a int);

call login('dba','') on class db_user;
drop class t1;
call drop_user('user1') on class db_user;

--+ holdcas off;
