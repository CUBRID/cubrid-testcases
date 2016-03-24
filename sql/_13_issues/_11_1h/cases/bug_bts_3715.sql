
select to_char('aaa');

select to_char(cast('aaa' as char(10)));



create table foo(a char(20), b varchar, c nchar(20), d nchar varying, e sequence(int));

insert into foo values('aaa', 'bbb', n'ccc', n'ddd', {1, 2, 3, 4, 5});

select * from foo order by 1;


select to_char(a) from foo order by 1;
select to_char(b) from foo order by 1;
select to_char(c) from foo order by 1;
select to_char(d) from foo order by 1;

--[er]
select to_char(e) from foo order by 1;


drop table foo;
