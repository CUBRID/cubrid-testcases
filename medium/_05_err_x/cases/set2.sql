autocommit off;
create class foo (a1 set(int));
insert into foo(a1) values({1});
create class foo1(b1 set(int));
insert into foo1 values( set( select a1 from foo));
rollback;
