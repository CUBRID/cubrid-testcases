autocommit off;
call login('dba', '') on class db_user;
call add_user('treyes','') on class db_user;
rollback;
