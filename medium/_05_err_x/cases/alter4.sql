autocommit off;
alter class joe._db_user add attribute age integer;
rollback work;
rollback;
