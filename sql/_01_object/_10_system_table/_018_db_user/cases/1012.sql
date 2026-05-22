--Test system table db_user's method:add_user()
--+ holdcas on;
call login('dba') on class db_user;
call add_user('test_user','password') on class _db_user;
call drop_user('test_user') on class _db_user;
commit;
--+ holdcas off;
