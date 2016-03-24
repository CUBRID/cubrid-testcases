--+ holdcas on;
--Test print_authorizations() methods on db_user to print public's authorizations
call login('dba') on class db_user;

call find_user('public') on class db_user to user_arg;

--+ holdcas off;
