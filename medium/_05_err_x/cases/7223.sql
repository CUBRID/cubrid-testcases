autocommit off;
create class foo1 (a int);
create class foo2 under foo1 (b int);
alter class foo2 add constraint U unique(b);
alter class foo1 add constraint U unique(a);
rollback;
