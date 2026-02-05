--Test system table _db_user's attribute:triggers
autocommit off;
call login('dba') on class db_user;
create user test_user ;

call login('test_user') on class db_user;
create class test_class(col1 integer, col2 varchar(20));

create trigger test_trigger
after rollback
execute print 'rollback by test_user';

select name, id, password, direct_groups, groups, authorization, triggers, is_loginable, is_system_created, comment from _db_user
where name = 'TEST_USER';
drop trigger test_trigger;


call login('dba') on class db_user;
drop class test_user.test_class;
drop user test_user;
commit;
autocommit on;
