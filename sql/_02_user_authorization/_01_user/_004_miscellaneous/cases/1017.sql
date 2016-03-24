--+ holdcas on;
--Use change_owner() methods to change a class to public
call login('dba') on class db_user;
call add_user('test_user') on class db_user;
create class t1(a int);

call change_owner('t1', 'test_user') on class db_authorizations;

select * from db_class where class_name='t1';

select * from db_class where class_name='t1';
drop class t1;
call drop_user('test_user') on class db_user;
--+ holdcas off;
