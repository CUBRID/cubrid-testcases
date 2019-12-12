--+ holdcas on;
--Test method change_owner() on  db_authorizations
call login('dba') on class db_user;
call add_user('test_user1') on class db_authorizations;
call add_user('test_user2') on class db_authorizations;

create class test_class(col1 integer, col2 varchar(20));
grant select on test_class to test_user;
call change_owner('test_class','test_user2') on class db_authorizations;
call login('test_user2') on class db_user;
insert into test_class values(999,'nhn');

call login('dba') on class db_user;
select class_name, owner_name from db_class
where  class_name = 'test_class';
drop class test_class;
call drop_user('test_user1') on class db_authorizations;
call drop_user('test_user2') on class db_authorizations;

--+ holdcas off;
