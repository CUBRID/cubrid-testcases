--TEST: [Analytic Functions] ERROR: System error (generate order_by) in ../../src/parser/xasl_generation.c (line: 5437) occurs in analytic functions with group by clause.

drop table if exists foo;

create table foo(a date, b int);
insert into foo values('1990-10-10', 10);
insert into foo values('1990-10-11', 20);
insert into foo values('1990-10-12', 30);

select a, rank() over(order by 1) from foo group by a order by 1;
select a, b, avg(b) over(partition by 2 order by 1) from foo group by a;

drop table foo;
