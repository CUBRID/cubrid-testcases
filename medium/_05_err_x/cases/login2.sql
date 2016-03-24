autocommit off;
call login ('dba','') on class db_user;
call drop_user ('arb_user') on class db_user;
call login ('dba','') on class db_user;
rollback;
