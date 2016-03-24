create table foo(a varchar, b char(10));
insert into foo values('aaa', 'aaa');

select cast(a as enum('aaa')) from foo;
select cast(b as enum('aaa')) from foo;

drop table foo;
