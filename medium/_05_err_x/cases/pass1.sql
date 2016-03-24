autocommit off;
call login ('user2', '') on class db_user;
call find_user ('user1') on class db_user to user1;
call set_password ('xyz') on user1;
call login('dba','') on class db_user;
rollback;
