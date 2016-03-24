autocommit off;
create index idx on joe.db_user(name);
rollback work;
rollback;
