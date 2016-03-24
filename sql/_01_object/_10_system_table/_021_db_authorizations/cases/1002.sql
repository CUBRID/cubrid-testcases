--+ holdcas on;
--Create user and drop user with method 'drop_user' of db_authorizations
call login('dba') on class db_user;
call add_user('test_user') on class db_authorizations;
select name from db_user order by 1;
call drop_user('test_user') on class db_authorizations;

--+ holdcas off;
