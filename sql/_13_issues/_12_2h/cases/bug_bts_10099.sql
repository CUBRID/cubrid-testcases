--TEST: [Analytic Functions] Result is inconsistent with Oracle when using a negative number as the offset of lead() analytic function. (BY DESIGN)


drop table if exists foo;

create table foo(a int, b int);

insert into foo values(1, 1);
insert into foo values(2, 2);

--No error occurs
select a, b, lead(a, -1, 999) over(order by a) from foo order by 1, 2, 3;

drop table foo;
