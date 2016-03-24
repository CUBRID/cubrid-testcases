--TEST: [Analytic Functions] 'Cannot coerce value' error occurs when using a row_number() function partitioned by a varchar column in ANY/SOME expression.

drop table if exists foo;

create table foo(a int primary key, b int, c varchar(10));
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'ccc');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');

select a, b, c from foo where a = any(select row_number() over(partition by c order by a) row_num from foo) order by a;
select a, b, c from foo where a = some(select row_number() over(partition by c order by a) row_num from foo) order by a;

drop table foo;

