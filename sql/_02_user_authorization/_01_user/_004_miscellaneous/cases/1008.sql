--+ holdcas on;
--[er]Test change_owner() methods 
call login('dba') on class db_user;
create class t1(a int);

call change_owner('t1', 'test_user') on class db_authorizations;


drop class t1;
call drop_user('test_user') on class db_user;
--+ holdcas off;
