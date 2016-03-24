--[er]Add member to noexists group
autocommit off;

call login('dba','') on class db_user;
call find_user('dba')on class db_user to admin;
call login('dba','') on class db_user;

call add_user ('test_user') on class db_user;
call add_member('user1') ON admin;

DROP user user1;
call drop_user ('test_user') on class db_user;

rollback;

autocommit on;

