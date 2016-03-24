--TEST: [Analytic Functions] Result of lead() analytic function is incorrect with limit clause.


drop table if exists foo;

create table foo(a int primary key, b varchar(10));

insert into foo values(1, 'aaa');
insert into foo values(2, 'bbb');
insert into foo values(3, 'bbb');
insert into foo values(4, 'bbb');
insert into foo values(5, 'aaa');

select a, b, lead(a) over(order by a) from foo limit 3;
select a, b, lead(a) over(order by a) from foo order by a limit 3;

drop table foo;
