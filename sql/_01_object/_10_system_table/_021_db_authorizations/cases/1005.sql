--+ holdcas on;
--Test method  print_authorizations() on  db_authorizations
call login('dba') on class db_user;
call add_user('test_user') on class db_authorizations;
select name from db_user order by 1;

create class test_class(col1 integer, col2 varchar(20));
grant select on test_class to test_user;

call drop_user('test_user') on class db_authorizations;
drop class test_class;

--+ holdcas off;
