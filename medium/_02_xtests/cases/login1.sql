autocommit off;

call login ('user1', 'xyz') on class db_user;
call login('dba', '') on class db_user;
rollback;
