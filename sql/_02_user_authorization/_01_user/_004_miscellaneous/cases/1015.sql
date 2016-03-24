--+ holdcas on;
--Test print_authorizations() methods on db_authorizations to retrieve dba's authorities;
call login('dba') on class db_user;

call get_owner('db_class') on  class db_authorizations to arg_owner;


--+ holdcas off;
