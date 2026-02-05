autocommit off;
revoke insert on joe._db_user from public;
rollback work;
rollback;
