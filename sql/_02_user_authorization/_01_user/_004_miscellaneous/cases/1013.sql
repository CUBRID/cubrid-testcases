--+ holdcas on;
--Test print_authorizations() methods on db_user to print dba's authorizations
call login('dba') on class db_user;

call find_user('dba') on class db_user to user_arg;

--+ holdcas off;
