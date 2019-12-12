create table t (i int, j int, k int);
insert into t values (1, 1, 1);
insert into t values (1, 1, 1);
insert into t values (1, 1, 2);
insert into t values (1, 1, 3);
insert into t values (1, 2, 1);
insert into t values (1, 2, 2);
insert into t values (1, 2, 2);

insert into t values (2, 1, 1);
insert into t values (2, 2, 2);
insert into t values (2, 3, 3);
insert into t values (2, 4, 4);

insert into t values (3, 1, 1);
insert into t values (3, 1, 2);
insert into t values (3, 2, 2);


-- no partition / order by
select min(distinct k)   over () as A, max(distinct k) over () as B, sum(distinct k)        over () as C, avg(distinct k)       over () as D from t order by i, j, k;

-- partition by i / no order by
select min(distinct k)   over (partition by i) as A, max(distinct k)       over (partition by i) as B, sum(k)        over (partition by i) as C, avg(distinct k)     over (partition by i) as D from t order by i, j, k;
select count(distinct k) over (partition by i) as C from t order by i, j, k;

-- partition by i / order by i
select min(distinct k)         over (partition by i order by i) as A, max(distinct k)       over (partition by i order by i) as B from t order by i, j, k;

drop table t;

