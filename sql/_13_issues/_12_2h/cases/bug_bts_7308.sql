--TEST: [Analytic Functions] Returned number of rows is incorrect when row_number() function is selected in ANY/SOME expression.

drop table if exists foo;

create table foo(a int primary key, b int, c smallint);
insert into foo values(1, 2, 100);
insert into foo values(2, 3, 200);
insert into foo values(3, 1, 300);
insert into foo values(4, 3, 200);
insert into foo values(5, 1, 100);


select a, b, c from foo where a = any(select row_number() over(partition by b order by a) row_num from foo) order by 1;

select a, b, c from foo where a = some(select row_number() over(partition by b order by a) row_num from foo) order by 1;

select a, b, c from foo where a = all(select row_number() over(partition by b order by a) row_num from foo) order by 1;


drop table foo;
