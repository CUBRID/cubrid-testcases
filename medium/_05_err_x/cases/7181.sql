autocommit off;
create class foo ( a int);
create class foo1 under foo;
insert into foo values(1);
insert into foo1 values(1);
alter foo add unique(a);
rollback;
