--TEST: [Analytic Functions] 'ERROR: Overflow occurred in multiplication context.' error occurs in var_samp() analytic function.

drop table if exists foo;

create table foo(a int, b int);

insert into foo values(100, 10000000);
insert into foo values(200, 20000000);
insert into foo values(100, 30000000);
insert into foo values(200, 40000000);
insert into foo values(100, 50000000);
insert into foo values(200, 70000000);
insert into foo values(100, 80000000);
insert into foo values(100, 10000000);

select var_samp(b) over(order by a, b) var_samp from foo order by 1;
select var_samp(b) over(partition by a order by b) var_samp from foo order by 1;


drop table foo;
