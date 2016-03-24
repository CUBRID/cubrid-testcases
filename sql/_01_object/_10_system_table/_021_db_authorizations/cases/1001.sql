--+ holdcas on;
--Create user with method 'add_user' of db_authorizations
call login('dba') on class db_user;
call add_user('test_user') on class db_authorizations;
select  name,id,password,direct_groups,groups,authorization from db_user order by 1;
drop user test_user;

--+ holdcas off;
