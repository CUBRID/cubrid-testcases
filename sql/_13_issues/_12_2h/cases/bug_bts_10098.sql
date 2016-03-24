--TEST: [Analytic Functions] Result is inconsistent with Oracle when passing a float argument to lead() analytic function. (BY DESIGN)


drop table if exists foo;

create table foo(a int);

insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);

--Result is incocsistent with Oracle.
select a, lead(a, 1.6) over(order by a) from foo order by 1, 2;

drop table foo;
