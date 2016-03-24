--TEST: [Analytic Functions] Result of stddev(a)/stddev(distinct a) over(partition by a) is incorrect when a is null.

drop table if exists foo;

create table foo(a int);

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(null);


select a, stddev(a) over(partition by a) from foo order by a;
select a, stddev(distinct a) over(partition by a) from foo order by a;

select a, stddev(a) over(order by a) from foo order by a;
select a, stddev(distinct a) over(order by a) from foo order by a;

drop table foo;
