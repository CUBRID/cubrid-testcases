--+ holdcas on;
--Test update statistics by common user on other's class
call login('dba') on class db_user;
create class t1 (c1 int);
call add_user('test_user') on class db_user;
call login('test_user') on class db_user;

update statistics on dba.t1;

call login('dba') on class db_user;
update statistics on t1;
grant alter on t1 to test_user;

call login('test_user') on class db_user;
update statistics on dba.t1;

call login('dba') on class db_user;
drop class t1;
call drop_user('test_user') on class db_user;
--+ holdcas off;
