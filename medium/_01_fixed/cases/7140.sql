autocommit off;
create class foo1;
create class foo2;
rename foo1 as abcd;
rename foo2 as b;
rollback;
