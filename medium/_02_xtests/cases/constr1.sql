autocommit off;
create class foo (a int unique)
insert into foo values(2)
select * from foo
update foo set a=a
rollback;
