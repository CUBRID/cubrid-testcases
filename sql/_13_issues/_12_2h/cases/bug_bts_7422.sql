--TEST: [Analytic Functions] System error (generate attr) occurs when using max() analytic function in a subquery.

drop table if exists foo;

create table foo(a int);
insert into foo values(1);
insert into foo values(2);
insert into foo values(3);
insert into foo values(4);
insert into foo values(4);

select (select max(a) over() from foo where a=1) from foo;
select (select max(a) over() from foo where a in(3, 100, 300)) from foo;
select (select max(a) over(partition by a) from foo where a>1 and a<3) from foo;
select (select max(a) over(order by a) from foo where a<5) from foo;


drop table foo;
