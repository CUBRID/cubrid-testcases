autocommit off;
create class foo (a int unique);
insert into foo values(1);
insert into foo values(2);
select * from foo;
rollback work;
rollback;
