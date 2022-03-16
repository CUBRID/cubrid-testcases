--+ holdcas on;
--[er]Cannot drop a user who own a virtual class;
call login('dba','') on class db_user;
create user user1 password 'a';
call login('user1','a') on class db_user;

create class t1(a int, b char(1));
create vclass vt1 as select a from t1;

call login('dba','') on class db_user;
drop class user1.t1;
call drop_user('user1') on class db_user;
drop vclass user1.vt1;
call drop_user('user1') on class db_user;

--+ holdcas off;
