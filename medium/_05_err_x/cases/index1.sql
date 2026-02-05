autocommit off;
create index idx on joe._db_user(name);
rollback work;
rollback;
