autocommit off;
create class foo(f varchar(20));
insert into foo values('01:00');
insert into foo values('01:01');
insert into foo values('01:02');
insert into foo values('01:03');
insert into foo values('01:04');
select to_time(f) from foo;
select to_time(f) from foo order by 1;
select to_time(f) from foo order by 1 desc;
rollback
rollback;
