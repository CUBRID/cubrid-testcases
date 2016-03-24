create table foo(a int);
insert into foo values(123456);

alter table foo modify a int not null default 222;
insert into foo values default;
select * from foo order by 1;

alter table foo change a b char(10) default 'abc';
insert into foo values default;
select * from foo order by 1;

drop table foo;
