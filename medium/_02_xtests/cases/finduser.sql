autocommit off;
call find_user ('foo_user') on class db_user;
rollback work;
rollback;
