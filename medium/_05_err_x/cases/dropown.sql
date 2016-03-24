autocommit off;
drop index idx on joe.db_user(name);
rollback work;
rollback;
