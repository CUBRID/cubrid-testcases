drop table if exists foo; 

create table foo(a int primary key, b int, c varchar(10));
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'bbb');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');

select a, b, c, rank() over() from foo order by 1;

select a, b, c, a+rank() over() from foo order by 1;

select a, b, c, a+b+rank() over() from foo order by 1;

select a+b+rank() over() from foo order by 1;

select a+b+rank() over(), a+b+rank() over() from foo order by 1;

select a+b+rank() over(), a+b+rank() over() , a+b+rank() over(), a+b+rank() over(), a+b+rank() over(), a+b+rank() over(), a+b+rank() over() from foo order by 1;

select a, b, c, row_number() over() from foo  order by 1;

drop table foo; 

create table foo(a int primary key, b int, c varchar(10)) partition by hash(a) partitions 3;
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'bbb');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');


select a, b, c, rank() over() from foo order by 1;

select a, b, c, a+rank() over() from foo order by 1;

select a, b, c, a+b+rank() over() from foo order by 1;

select a+b+rank() over() from foo order by 1;

select a+b+rank() over(), a+b+rank() over() from foo order by 1;

select a+b+rank() over(), a+b+rank() over() , a+b+rank() over(), a+b+rank() over(), a+b+rank() over(), a+b+rank() over(), a+b+rank() over() from foo order by 1;

select a, b, c, row_number() over() from foo  order by 1;

drop table foo; 
