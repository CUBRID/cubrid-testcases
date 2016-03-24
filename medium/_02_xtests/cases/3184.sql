autocommit off;
create class foo (n int unique);
insert into foo values (1);
insert into foo values (2);
update foo set n = n-1;
update foo set n = n+1;
select * from foo;
rollback work;
rollback;
