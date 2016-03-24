autocommit off;
create class dv(v int default 123);
insert into dv default values into x;
select * from dv where dv = x;
create class foo(stuff set());
insert into foo default values to myvar;
select myvar from foo;
rollback work;
rollback;
