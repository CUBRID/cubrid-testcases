--TEST: [Analytic Functions] Analytic function cannot be used in a statement which has a group by clause.

drop table if exists foo;

create table foo(a int, b int);

insert into foo values(1, 10);
insert into foo values(1, 12);
insert into foo values(1, 24);
insert into foo values(2, 34);
insert into foo values(2, 22);


select a, row_number() over(order by a) from foo group by a order by a;
select * from (select a, count(a) over(order by a) as b from foo group by a order by a);
select a, min(b), rank() over(order by a) from foo group by a order by a;
select a, max(b) over(order by a) from foo group by a, b order by a, b;
select a, sum(min(b)) over(order by a) from foo group by a order by a;
select a, sum(b), avg(sum(b)) over(partition by sum(b) order by a) from foo group by a order by a;
select a, stddev(max(b)) over(order by a) from foo group by a order by a;
select a, b, var_pop(b) over(partition by b order by a) from foo group by a, b order by a;
select a, ntile(4) over(order by a) from foo group by a order by a;
select a, trunc(avg(b), 2), lead(trunc(avg(b), 2), 1, 999) over(order by a) from foo group by a order by a;


drop table foo;



--case by dev
drop table if exists t;
create table t (v int, p int, o int);
insert into t values (1, 1, 1);
insert into t values (2, 1, 2);
insert into t values (3, 1, 3);
insert into t values (4, 1, 4);
insert into t values (5, 2, 1);
insert into t values (6, 2, 2);
insert into t values (7, 2, 3);
insert into t values (8, 3, 1);
insert into t values (9, 3, 2);
insert into t values (1, 1, 1);
insert into t values (2, 1, 2);
insert into t values (3, 1, 3);

-- simple
select v, p, sum(v) over () from t group by v, p order by 1, 2;
select v, p, sum(v) over (partition by p) from t group by v, p order by 1, 2;
select v, p, o, sum(v) over (partition by p order by o) as x from t group by v, p, o order by 1, 2, 3;

-- aggregate params
select p, trunc(avg(v), 2), sum(o), trunc(stddev_pop(avg(p) + sum(o)) over (), 2) from t group by p order by 1 desc, 2, 3;
select p, trunc(avg(v), 2), sum(o), trunc(stddev_pop(avg(p) + sum(o)) over (order by sum(o) desc), 2) as x from t group by p order by 1 desc, 2, 3;
select sum(p), trunc(avg(v) + sum(v), 2), trunc(var_pop(avg(v) + sum(v)) over (partition by sum(p)), 2) as x from t group by o order by 1 desc, 2;
select sum(p), trunc(avg(v) + sum(v), 2), trunc(var_pop(avg(v) + sum(v)) over (partition by sum(p) order by var_pop(v)), 2) as x from t group by o order by 1 desc, 2;

-- hidden in subqueries (should not rewrite)
select v, p, sum(v) over (partition by p) as x, (select trunc(avg(v), 2) from t group by cast(p/1000 as int)) as y from t order by 1, 2, 3, 4;
select v, p, sum(v) over (partition by p) as x, (select trunc(avg(v), 2) from t where t.v = k.v and t.p = k.p group by v, p) as y from t k order by 1, 2, 3, 4;
select v, p, sum(v) over (partition by p) as x, u.* from t, (select trunc(avg(v), 2) from t group by p) u order by 1, 2, 3, 4;
select p, trunc(avg(v), 2), u.x from t, (select sum(v) over (partition by p) as x from t) u group by p, u.x order by 1, 2, 3;

-- other
select v, p, o, sum(v) over (partition by p order by o) as x from t group by v, p, o order by 1, 2, 3 limit 3;
select sum(p), trunc(avg(v) + sum(v), 2), trunc(var_pop(avg(v) + sum(v)) over (partition by sum(p)), 2) as x from t group by o having sum(p) < 7 order by 1 desc, 2;
select sum(p), trunc(avg(v) + sum(v), 2), trunc(var_pop(avg(v) + sum(v)) over (partition by sum(p)), 2) as x from t where p < 3 group by o order by 1 desc, 2;


drop table t;

