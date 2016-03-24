--TEST: [Analytic Functions] All the results of var_samp(a) over(order by a) will become null when there are no duplicate values in column a.

drop table if exists foo;

create table foo(a int);

insert into foo values(10);
insert into foo values(20);
insert into foo values(30);
insert into foo values(40);

select a, var_samp(a) over() vs from foo order by 1;
select a, var_samp(a) over(order by a) vs from foo order by 1;
select a, var_samp(a) over(partition by a order by a desc) vs from foo order by 1;

drop table foo;
