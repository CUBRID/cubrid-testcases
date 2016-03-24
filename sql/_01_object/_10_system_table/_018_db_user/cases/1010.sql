--Test system table db_user's method:drop_member()
--+ holdcas on;
call login('dba') on class db_user;
call add_user('test_user') on class db_user to test_group;
call add_user('test_mem') on class db_user;
call add_member('test_mem') on test_group;


call drop_member('test_mem') on test_group;

call drop_user('test_user') on class db_user;
call drop_user('test_mem') on class db_user;
commit;
--+ holdcas off;
