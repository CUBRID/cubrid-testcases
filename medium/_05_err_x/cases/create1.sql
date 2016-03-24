autocommit off;
create class foo.bogus (fake string);
rollback work;
rollback;
