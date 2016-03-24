--TEST: [Analytic Functions] order by position in over() clause of row_number() function does not work.


drop table if exists foo;

create table foo(col1 int, col2 smallint);

insert into foo values(10000, 100);
insert into foo values(10000, 200);
insert into foo values(20000, 100);
insert into foo values(20000, 300);
insert into foo values(30000, 100);
insert into foo values(30000, 300);
insert into foo values(40000, 100);
insert into foo values(50000, 100);
insert into foo values(50000, 200);
insert into foo values(50000, 100);


select col1, col2, rank() over(order by 2) rk from foo;

select col1, col2, max(col1) over(partition by 2) rk from foo;

select col1, col2, sum(col2) over(partition by 1 order by 2) rk from foo;


--[er] out of range
select col1, col2, avg(col2) over(partition by 5) rk from foo;
select col1, col2, dense_rank() over(partition by 1 order by 10) rk from foo;


drop table foo;
