autocommit off;
revoke insert on joe.db_user from public;
rollback work;
rollback;
