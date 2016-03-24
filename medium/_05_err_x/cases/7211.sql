autocommit off;
create class foo1 (a int unique);
create class foo2 as subclass of foo1;
alter class foo2 drop constraint 'u_foo1_a';
alter class foo1 drop constraint 'u_foo1_a';
rollback;
