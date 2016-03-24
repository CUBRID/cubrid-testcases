--TEST: [Analytic Functions] Select result of row_number() function becomes null when it is used in a correlated subquery.


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

select c.a, (select row_number() over(partition by t.str order by t.a) from t where c.a=t.a) row_num, c.b, c.c from foo c order by 1;

drop foo, t;


create table foo(a int);
insert into foo values(1), (2), (3);
select (select max(a) over() from foo where a=1) from foo order by 1;
drop foo;


create table t (i int, j int);
create table u (i int, j int, k char(10));

insert into t values (1, 1), (1, 2), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3);
insert into u values (1, 1, 'a'), (1, 2, 'b'), (1, 3, 'c'), (1, 4, 'd'), (2, 5, 'e');

-- correlated subquery in select list
select i, (select row_number() over (order by i) from u where t.i = u.j), j from t order by i, j;
select i, (select row_number() over (partition by i) from u where t.i = u.j) row_num, j from t order by i, j;
select i, (select row_number() over (partition by i order by j) row_num from u where t.i = u.j) row_num, j from t order by i, j;
select i, (select row_number() over (order by i) from u where t.i < u.j) row_num, j from t order by i, j;

-- uncorrelated subquery in select list
select i, (select avg(j) over () from u where j > 4) aaa, j from t order by i, j;
select i, (select avg(j) over (partition by i) from u where j > 4) aaa, j from t order by i, j;
select i, (select avg(j) over (partition by i order by j) from u where j > 4) aaa, j from t order by i, j;

-- subquery in WHERE clause
select i, j from t where cast(i as int) > any (select row_number() over () from u where i < 2) order by i, j;
select i, j from t where cast(i as int) > any (select row_number() over (partition by i) from u where i < 2) order by i, j;
select i, j from t where cast(i as int) > any (select row_number() over (partition by i order by j) from u where i < 2) order by i, j;

drop t, u;

