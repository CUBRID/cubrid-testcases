--TEST: [Analytic Functions] The order by [column_name] result is incorrect while selecting an analytic function if there is an index on the column


create table foo(a int primary key, b int);

insert into foo values(1, 1);
insert into foo values(2, 1);
insert into foo values(3, 1);
insert into foo values(4, 2);
insert into foo values(5, 2);


select a, b, row_number() over(partition by b order by a desc) row_num from foo order by a;


drop table foo;



create table foo(a int, b int, index i(a));

insert into foo values(1, 1);
insert into foo values(2, 1);
insert into foo values(3, 1);
insert into foo values(4, 2);
insert into foo values(5, 2);


select a, b, row_number() over(partition by b order by a desc) row_num from foo order by a;


drop table foo;
