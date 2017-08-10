--+ holdcas on;
--Create user and print this user's authority
call login('dba','') on class db_user;
call add_user('test_user') on class db_user;
create class test_class(a int);
grant select on test_class to test_user;
grant update on test_class to test_user;
grant alter on test_class to test_user;
grant execute on test_class to test_user;
call find_user('test_user') on class db_user to user_arg;
call print_authorizations() on user_arg;

call drop_user('test_user') on class db_user; 
drop class test_class;
--+ holdcas off;
