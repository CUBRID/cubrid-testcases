autocommit off;
create class bogus (fake joe._db_user);
rollback work;
rollback;
