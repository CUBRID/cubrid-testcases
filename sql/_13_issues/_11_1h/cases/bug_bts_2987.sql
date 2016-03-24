create table foo(a int);
insert into foo values(123456);

alter table foo modify a int not null;
alter table foo change a b char(10);

select * from foo;

drop table foo;
