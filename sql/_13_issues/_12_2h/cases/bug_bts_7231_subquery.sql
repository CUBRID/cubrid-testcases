--extended cases for CUBRIDSUS-7231


create table t (i int, j int, k int);
insert into t values (1, 1, 1);
insert into t values (1, 2, 2);
insert into t values (1, 3, 3);
insert into t values (2, 1, 1);
insert into t values (2, 2, 2);
insert into t values (3, 1, 1);
insert into t values (3, 2, 2);

create table u (i int, j int);
insert into u values (1, 1);
insert into u values (1, 2);
insert into u values (2, 1);
insert into u values (2, 2);
insert into u values (2, 3);

-- correlated
select (select avg(u.j) over (partition by u.i order by t.i,t.j,t.k,u.i,u.j) + avg(t.j) over (partition by t.i order by t.i,t.j,t.k,u.i,u.j) from t where rownum < 2 order by i, j) from u;

-- uncorrelated
select (select row_number() over (partition by t.i) from t order by 1 desc limit 1) + avg(u.j) over (partition by u.i) from u;

-- derived table
select * from (select avg(j) over (partition by i) * stddev_samp(j) over (partition by i order by k) as x from t where rownum < 4 order by 1) a, (select row_number() over (partition by i order by j) as y from u where rownum < 4 order by 1) b order by 1, 2;

-- subquery argument
select 
	avg((select u.j from u where u.i = t.i and rownum < 2 order by j)) over (partition by i) + 
	stddev_samp((select u.j from u where u.i = t.i and rownum < 2 order by j)) over (partition by i) as x
from t order by 1;

drop t, u;
