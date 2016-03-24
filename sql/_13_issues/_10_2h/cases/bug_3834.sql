create table foo(a int, b int, c char(10), d datetime);

insert into foo values(1, 2, '1', '11:54:33.812 AM 08/17/2010');
insert into foo values(1, 2, '1', '11:54:33.656 AM 08/17/2010');
insert into foo values(1, 2, '1', '11:54:33.250 AM 08/17/2010');
insert into foo values(1, 2, '1', '11:54:33.468 AM 08/17/2010');

select * from foo order by 4;

select a,b,c,d, DATE_FORMAT(d, '%Y-%m-%d %H:%i:%s') AS col1 from foo order by d;
select *, DATE_FORMAT(d, '%Y-%m-%d %H:%i:%s') AS col1 from foo order by d;
select *, a, b from foo order by d;

drop table foo;
