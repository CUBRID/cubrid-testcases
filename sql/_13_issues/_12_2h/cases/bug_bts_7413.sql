--TEST: [Analytic Functions] Result of expression like a+b is incorrect when selecting with an analytic function.

drop table if exists foo;

create table foo(a int, b int, c varchar(10));
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'ccc');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');

select a+b from foo order by 1;

select a, a+b, max(a) over() from foo order by 1;

select b, a+b, count(a) over() from foo order by 1;

select a, b, a+b, avg(a) over(order by b) from foo order by 1;

select a+b, sum(b) over(partition by c order by a) from foo order by 1;


drop table foo;
