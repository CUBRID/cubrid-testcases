autocommit off;
call login ('user1', '') on class db_user;
call find_user ('gruppe') on class db_user to gruppe;
call drop_member ('foo_user') on gruppe;
call login ('dba', '') on class db_user;
rollback;
