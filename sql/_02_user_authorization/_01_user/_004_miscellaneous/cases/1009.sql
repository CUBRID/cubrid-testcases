--+ holdcas on;
--[er]Test get_owner() methods 
call login('dba') on class db_user;
call add_user('test_user') on class db_user;

call change_owner('t1') on class db_authorizations;


drop class t1;
call drop_user('test_user') on class db_user;
--+ holdcas off;
