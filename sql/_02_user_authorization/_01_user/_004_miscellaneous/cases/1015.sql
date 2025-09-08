--+ holdcas on;
--Test print_authorizations() methods on db_root to retrieve dba's authorities;
call login('dba') on class db_user;

call get_owner('db_class') on  class db_root to arg_owner;


--+ holdcas off;
