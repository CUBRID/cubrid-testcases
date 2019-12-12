--extended cases for CUBRIDSUS-7231


create table t (i int, j int, k int);
insert into t values (1, 1, 1);
insert into t values (1, 2, 2);
insert into t values (1, 3, 3);
insert into t values (2, 1, 1);
insert into t values (2, 2, 2);
insert into t values (3, 1, 1);
insert into t values (3, 2, 2);

-- multiple analytic functions in func
select
	(1.5 in (k + 100, avg(j) over (partition by i))) as i15,
	(2 in (k + 100, avg(j) over (partition by i))) as i2,
	(3 in (k + 100, avg(j) over (partition by i))) as i3
from t order by 1, 2, 3;

select
	(1.5 in (k + 100, avg(j) over (partition by i))) as i15,
	(2 in (k + 100, avg(j) over (partition by i))) as i2,
	(avg(j) over (partition by i) in (k + 100, avg(j) over (partition by i), avg(j) over (partition by i) + 100)) as i3
from t order by 1, 2, 3;

-- as sort spec
select i, j, (2 in (k + 100, avg(j) over (partition by i))) from t order by (2 in (k + 100, avg(j) over (partition by i))), 1, 2;
select i, j from t order by (2 in (k + 100, avg(j) over (partition by i))), 1, 2;

drop table t;
