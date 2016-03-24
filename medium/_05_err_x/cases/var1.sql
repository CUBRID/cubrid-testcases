autocommit off;
call login ('user1', '') on class db_user;
call find_user ('user1') on class db_user to user1;
call set_password ('') on user2;
call login('dba','') on class db_user;
rollback;
