--+ holdcas on;
--Test print_authorizations() methods on db_user
call login('dba') on class db_user;
call add_user('test_user') on class db_user;
create class t1(a int);
grant select on t1 to test_user;
grant update on t1 to test_user;
grant delete on t1 to test_user;
grant alter on t1 to test_user;

call find_user('test_user') on class db_user to user_arg;
drop class t1;
call drop_user('test_user') on class db_user;

--+ holdcas off;
