--+ holdcas on;
--Test get_owner() methods 

call login('dba') on class db_user;
call add_user('test_user') on class db_user;
create class t1(a int);

call change_owner('t1', 'test_user') on class db_authorizations;
call get_owner('test_user.t1') on  class db_authorizations;

select * from db_class 
where owner_name='TEST_USER';
drop class test_user.t1;
call drop_user('test_user') on class db_user;

--+ holdcas off;
