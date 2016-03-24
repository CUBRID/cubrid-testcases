--TEST: [Analytic Functions] Results of sum(a) analytic function become null when the first value of a is null


drop table if exists foo;

create table foo(a int);

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);
insert into foo values(null);
insert into foo values(null);

select a, sum(a) over(order by a desc) from foo;

select a, sum(a) over(order by a) from foo;
select a, sum(a) over(partition by a order by a) from foo;

select a, avg(a) over(order by a) from foo;
select a, avg(a) over(partition by a order by a) from foo;


drop table foo;
