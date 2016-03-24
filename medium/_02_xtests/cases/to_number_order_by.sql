autocommit off;
create class foo(f varchar(10));
insert into foo values('1');
insert into foo values('2');
insert into foo values('3');
insert into foo values('4');
insert into foo values('5');
select to_number(f) from foo;
select to_number(f) from foo order by 1;
select to_number(f) from foo order by 1 desc;
rollback
rollback;
