--TEST: [Analytic Functions] Error occurs when row_number() function with an order_by_clause is selected in a subquery.


drop table if exists foo;

create table foo(a int primary key, b int, c smallint);
insert into foo values(1, 2, 5);
insert into foo values(2, 3, 8);
insert into foo values(3, 1, 16);
insert into foo values(4, 3, 16);
insert into foo values(5, 1, 5);

select (select count(*) over() from foo where a=4) cnt from foo order by 1;

select (select row_number() over(order by b) from foo where a=5) rn from foo order by 1;

select (select row_number() over(order by b desc) from foo where a > any {4, 5, 6}) rn from foo order by 1;

select (select row_number() over(partition by c order by b) from foo where a > some(select a from foo where a=4)) rn from foo order by 1;

select a, b, (select count(*) over() from foo where a=4) cnt, (select row_number() over(order by b) from foo where a=5) rn1, (select row_number() over(partition by c order by b) from foo where a > some(select a from foo where a=4)) rn2 from foo order by 1;


--[er]
select (select row_number() over(partition by c order by b) from foo where a > some(select b from foo)) from foo order by 1;


drop table foo;
