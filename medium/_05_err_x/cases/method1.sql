autocommit off;
call login ('dba', '') on class db_user;
call add_user ('foo', '') on class employees_v;
call login ('dba', '') on class db_user;
rollback;
