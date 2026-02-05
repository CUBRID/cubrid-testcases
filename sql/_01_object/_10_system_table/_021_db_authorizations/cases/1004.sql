--+ holdcas on;
--Test method info() on  db_root
call login('dba') on class db_user;
call add_user('test_user') on class db_root;
select name from _db_user order by 1;
call info('test_user') on class db_root;
call drop_user('test_user') on class db_root;

--+ holdcas off;
