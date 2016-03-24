autocommit off;
alter class joe.db_user add attribute age integer;
rollback work;
rollback;
