--TEST: [Analytic Functions] Transaction aborted and core dumped when executing row_number() analytic function


drop table if exists foo;

create table foo(a int primary key, b int, c smallint);
insert into foo values(1, 2, 5);
insert into foo values(2, 3, 8);
insert into foo values(3, 1, 16);
insert into foo values(4, 3, 16);
insert into foo values(5, 1, 5);

create table t(a int, str varchar(10));
insert into t values(1, 'a');
insert into t values(4, 'a');
insert into t values(2, 'b');
insert into t values(3, 'c');


select a, b, c from foo where a in (select row_number() over(partition by str order by a) row_num from t) order by 1;
select c.a, (select row_number() over(partition by t.str order by t.a) from t where c.a=t.a) row_num, c.b, c.c from foo c order by 1;


drop table foo;
drop table t;
