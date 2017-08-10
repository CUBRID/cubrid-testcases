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

-- multiple analytic functions in expression
select avg(i) over () + avg(j) over () + avg(k) over () as expr from t order by 1;
select avg(i) over (partition by j order by k) + avg(j) over (partition by i order by k) as expr1, avg(j) over (partition by i order by k) + avg(k) over (partition by i order by j) as expr2 from t order by 1, 2;
select i, avg(i) over (partition by j order by k) + avg(j) over (partition by i order by k) * k as expr1, avg(j) over (partition by i order by k) * i + avg(k) over (partition by i order by j) as expr2, j, k from t order by 1, 2, 3, 4, 5;

-- analytic in expression subtree
select (stddev_samp(k) over (partition by i) + k) * (j + sqrt(stddev_pop(j) over (partition by i order by k))) + (i + j + sum(j) over (partition by i)) * (k + max(i) over ()) as expr, avg(j) over (partition by i, k) as af from t order by 1, 2;

-- joins
select row_number() over (partition by u.i order by u.j) + row_number() over (partition by t.i order by t.j, t.k) as rn, avg(u.j) over (partition by u.i) * sum(t.j) over (partition by t.i) as av from ( select * from t order by 1,2,3) t inner join (select * from u order by 1,2) u on t.i = u.i order by 1, 2;
select row_number() over (partition by u.i order by u.j) + row_number() over (partition by t.i order by t.j, t.k) as rn, avg(u.j) over (partition by u.i) * sum(t.j) over (partition by t.i) as av from (select * from t order by 1,2,3) t left join (select * from u order by 1,2) u on t.i = u.i order by 1, 2;
select row_number() over (partition by u.i order by u.j) + row_number() over (partition by t.i order by t.j, t.k) as rn, avg(u.j) over (partition by u.i) * sum(t.j) over (partition by t.i) as av from (select * from t order by 1,2,3) t right join (select * from u order by 1,2) u on t.i = u.i order by 1, 2;
select row_number() over (partition by u.i order by u.j) + row_number() over (partition by t.i order by t.j, t.k) as rn, avg(u.j) over (partition by u.i) * sum(t.j) over (partition by t.i) as av from (select * from t order by 1,2,3) t, (select * from u order by 1,2) u order by 1, 2;

select stddev_samp(u.j) over (partition by u.i order by u.j) + stddev_pop(t.k) over (partition by t.i order by t.j) as ss, count(u.j) over (partition by u.i) * max(t.j) over (partition by t.i) as av from t inner join u on t.i = u.i order by 1, 2;
select stddev_samp(u.j) over (partition by u.i order by u.j) + stddev_pop(t.k) over (partition by t.i order by t.j) as ss, count(u.j) over (partition by u.i) * max(t.j) over (partition by t.i) as av from t left join u on t.i = u.i order by 1, 2;
select stddev_samp(u.j) over (partition by u.i order by u.j) + stddev_pop(t.k) over (partition by t.i order by t.j) as ss, count(u.j) over (partition by u.i) * max(t.j) over (partition by t.i) as av from t right join u on t.i = u.i order by 1, 2;
select stddev_samp(u.j) over (partition by u.i order by u.j) + stddev_pop(t.k) over (partition by t.i order by t.j) as ss, count(u.j) over (partition by u.i) * max(t.j) over (partition by t.i) as av from t, u order by 1, 2;

-- with predicates
select count(*) over (partition by i) as a1, count(*) over (partition by j) as a2, if (count(*) over (partition by i) < count(*) over (partition by j), 1, 0) * 1000 as if1 from t order by 1, 2, 3;
select count(*) over (partition by i) as a1, count(*) over (partition by j) as a2, avg(j) over (partition by k order by i) * 1000, if (count(*) over (partition by i) < count(*) over (partition by j), avg(j) over (partition by k order by i), 0) * 1000 as if1 from t order by 1, 2, 3, 4;

select case avg(j) over (partition by i order by j) when 1 then count(*) over (partition by i) when 1.5 then avg(j) over (partition by i) else 0 end abc from t order by 1;
select case avg(j) over (partition by i order by j) when 1 then count(*) over (partition by i) when 1.5 then avg(j) over (partition by i) when avg(i) over (partition by i) + 1 then 100 end abc from t order by 1;

-- as sort spec
select i, j from t order by row_number() over (partition by i order by j), row_number() over (partition by j order by i) desc, 1, 2;
select i, j from t order by stddev_pop(i) over (partition by i order by j), avg(i) over (partition by j order by i) desc, 1, 2;
select i, j from t order by stddev_pop(i) over (partition by i order by j) - avg(i) over (partition by j order by i) desc, 1, 2;

select i, j, stddev_pop(i) over (partition by i order by j) - avg(i) over (partition by j order by i) as ex1 from t order by stddev_pop(i) over (partition by i order by j) - avg(i) over (partition by j order by i) desc, 1, 2;

drop table t;
drop table u;



