create table foo(a char(5));

--[er]
insert into foo values('123456');
insert into foo values(repeat('x', 6));
insert into foo values(space(6));

select * from foo order by 1;
select char_length(a) from foo;

drop table foo;


