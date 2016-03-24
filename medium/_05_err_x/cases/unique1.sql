autocommit off;
create class foo (a set(int) unique);
create class foo1 (a multiset(int) unique);
create class foo2 (a sequence(int) unique);
rollback;
