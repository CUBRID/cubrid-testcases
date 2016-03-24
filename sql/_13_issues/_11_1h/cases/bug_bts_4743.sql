create table foo(a char(5));
insert into foo values('aaa');
select * from foo;

alter table foo change a a numeric;
select * from foo;

drop table foo;


