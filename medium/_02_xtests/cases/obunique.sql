autocommit off;
create class foo (a int unique);
insert into foo values (1) into :p1;
select * from foo;
update object :p1 set a = 2;
select * from foo;
rollback;
