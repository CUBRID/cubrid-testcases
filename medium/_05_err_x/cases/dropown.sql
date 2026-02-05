autocommit off;
drop index idx on joe._db_user(name);
rollback work;
rollback;
