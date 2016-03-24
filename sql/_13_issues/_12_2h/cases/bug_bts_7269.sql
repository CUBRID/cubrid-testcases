--TEST: [Analytic Functions] order by c_alias is not supported in analytic_clause, NOT A BUG


drop table if exists foo;

create table foo(a int);

insert into foo values(1);
insert into foo values(1);

-[er] invalid usage
select a as b, row_number() over(order by b) from foo;

select row_number() over (order by b) from (select a as b from foo) order by 1;

drop table foo;
