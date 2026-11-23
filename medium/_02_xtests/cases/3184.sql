autocommit off;
create class foo (n int unique);
insert into foo values (1);
insert into foo values (2);
update foo set n = n-1 order by n;
update foo set n = n+1 order by n;
select * from foo order by n;
rollback work;
rollback;
