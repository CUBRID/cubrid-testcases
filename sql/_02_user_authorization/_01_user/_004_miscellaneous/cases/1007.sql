--+ holdcas on;
--Test print_authorizations() methods on db_authorizations
call login('dba') on class db_user;
call add_user('test_user') on class db_user;
create class t1(a int);
grant select on t1 to test_user;
grant update on t1 to test_user;
grant delete on t1 to test_user;
grant alter on t1 to test_user;

call change_owner('t1', 'test_user') on class db_authorizations;
call get_owner('test_user.t1') on  class db_authorizations to arg_owner;
drop class test_user.t1;
call drop_user('test_user') on class db_user;

--+ holdcas off;
