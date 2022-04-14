--+ holdcas on;
--Test method  get_owner() on  db_authorizations
call login('dba') on class db_user;
call add_user('test_user') on class db_authorizations;


create class test_class1(col1 integer, col2 varchar(20));
create class test_class2(col1 integer, col2 varchar(20));
grant select on test_class1 to test_user;
grant insert on test_class1 to test_user;
grant alter on test_class2 to test_user;
grant update on test_class2 to test_user;

call change_owner('test_class1','test_user') on class db_authorizations;
call get_owner('test_user.test_class1') on class db_authorizations to test_class1_owner;

call login('dba') on class db_user;
drop class test_user.test_class1;
drop class test_class2;
call drop_user('test_user') on class db_authorizations;

--+ holdcas off;
