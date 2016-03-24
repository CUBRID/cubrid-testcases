--+ holdcas on;
--Test method find_user() on  db_authorizations
call login('dba') on class db_user;
call add_user('test_user') on class db_authorizations;
select name from db_user order by 1;
call find_user('test_user') on class db_authorizations;
call drop_user('test_user') on class db_authorizations;

--+ holdcas off;
