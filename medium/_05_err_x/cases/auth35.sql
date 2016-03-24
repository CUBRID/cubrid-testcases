autocommit off;
create class bogus (fake joe.db_user);
rollback work;
rollback;
