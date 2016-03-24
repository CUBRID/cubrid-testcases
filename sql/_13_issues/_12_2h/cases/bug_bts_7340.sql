--TEST: [Analytic Functions] Result is inconsistent with Oracle when selecting multiple analytic functions in one statement.

drop table if exists foo;

create table foo(a int, b int, c varchar(10));
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'bbb');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');


select a, b, c, row_number() over(order by a) row_num1, row_number() over(order by b) row_num2 from foo order by 2, 1;
select a, b, c, row_number() over(partition by a) row_num1, row_number() over(order by b) row_num2 from foo order by 2, 1;
select a, b, c, row_number() over(order by a) row_num1, row_number() over(partition by a order by b) row_num2 from foo order by 2, 1;

drop table foo;
