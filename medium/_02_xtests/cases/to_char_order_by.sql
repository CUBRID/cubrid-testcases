autocommit off;
create class foo(f numeric);
insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);
insert into foo values(5);
select to_char(f) from foo ;
select to_char(f) from foo order by 1;
select to_char(f) from foo order by 1 desc;
rollback
create class foo(f date);
insert into foo values(date'02/01/2000');
insert into foo values(date'02/02/2000');
insert into foo values(date'02/03/2000');
insert into foo values(date'02/04/2000');
insert into foo values(date'02/05/2000');
select to_char(f) from foo;
select to_char(f) from foo order by 1;
select to_char(f) from foo order by 1 desc;
rollback
create class foo(f time);
insert into foo values(time'02:01');
insert into foo values(time'02:02');
insert into foo values(time'02:03');
insert into foo values(time'02:04');
insert into foo values(time'02:05');
select to_char(f) from foo;
select to_char(f) from foo order by 1;
select to_char(f) from foo order by 1 desc;
rollback
create class foo(f timestamp);
insert into foo values(timestamp'02:01 02/01/2000');
insert into foo values(timestamp'02:02 02/02/2000');
insert into foo values(timestamp'02:03 02/03/2000');
insert into foo values(timestamp'02:04 02/04/2000');
insert into foo values(timestamp'02:05 02/05/2000');
select to_char(f) from foo;
select to_char(f) from foo order by 1;
select to_char(f) from foo order by 1 desc;
rollback
rollback;
