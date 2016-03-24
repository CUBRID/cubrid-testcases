--+ holdcas on;
--Test print_authorizations() methods on db_authorizations to retrieve public's authorities;

call login('dba') on class db_user;
create class t1(a int);
call change_owner('t1', 'public') on class db_authorizations;
call get_owner('t1') on  class db_authorizations to arg_owner;
drop class t1;

--+ holdcas off;
