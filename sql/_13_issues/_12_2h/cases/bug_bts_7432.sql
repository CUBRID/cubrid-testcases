--TEST: [Analytic Functions] Result of stddev() analytic function is incorrect when there is an order_by_clause inside the analytic_clause.

drop table if exists foo;

create table foo(a int);
insert into foo values(1);
insert into foo values(2);
insert into foo values(3);

select a, stddev(a) over(order by a) std1, stddev(a) over() std2 from foo order by 1;
select a, stddev(a) over(partition by a order by a) std1, stddev(a) over(partition by a) std2 from foo order by 1;

drop table foo;
