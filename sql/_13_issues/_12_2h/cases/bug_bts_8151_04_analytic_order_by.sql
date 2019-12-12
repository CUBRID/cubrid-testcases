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
select min(k)         over () as A, max(k)       over () as B, sum(k)        over () as C, avg(k)       over () as D from t order by i, j, k;
select stddev_samp(k) over () as A, var_samp(k)  over () as B, count(k)      over () as C, rank()       over () as D from t order by i, j, k;
select stddev_pop(k)  over () as A, var_pop(k)   over () as B, dense_rank()  over () as C, row_number() over () as D from t order by i, j, k;

-- partition by i / no order by
select min(k)         over (partition by i) as A, max(k)       over (partition by i) as B, sum(k)        over (partition by i) as C, avg(k)     over (partition by i) as D from t order by i, j, k;
select dense_rank()   over (partition by i) as A, row_number() over (partition by i) as B, stddev_pop(k) over (partition by i) as C, var_pop(k) over (partition by i) as D from t order by i, j, k;
select stddev_samp(k) over (partition by i) as A, var_samp(k)  over (partition by i) as B, count(k)      over (partition by i) as C, rank()     over (partition by i) as D from t order by i, j, k;

-- partition by i / order by i
select min(k)         over (partition by i order by i) as A, max(k)       over (partition by i order by i) as B, sum(k)        over (partition by i order by i) as C, avg(k)     over (partition by i order by i) as D from t order by i, j, k;
select dense_rank()   over (partition by i order by i) as A, row_number() over (partition by i order by i) as B, stddev_pop(k) over (partition by i order by i) as C, var_pop(k) over (partition by i order by i) as D from t order by i, j, k;
select stddev_samp(k) over (partition by i order by i) as A, var_samp(k)  over (partition by i order by i) as B, count(k)      over (partition by i order by i) as C, rank()     over (partition by i order by i) as D from t order by i, j, k;

-- partition by i / order by j
select min(k)         over (partition by i order by j) as A, max(k)       over (partition by i order by j) as B, sum(k)        over (partition by i order by j) as C, avg(k)     over (partition by i order by j) as D from t order by i, j, k;
select dense_rank()   over (partition by i order by j) as A, row_number() over (partition by i order by j) as B, stddev_pop(k) over (partition by i order by j) as C, var_pop(k) over (partition by i order by j) as D from t order by i, j, k;
select stddev_samp(k) over (partition by i order by j) as A, var_samp(k)  over (partition by i order by j) as B, count(k)      over (partition by i order by j) as C, rank()     over (partition by i order by j) as D from t order by i, j, k;

-- partition by i / order by j desc
select min(k)         over (partition by i order by j desc) as A, max(k)       over (partition by i order by j desc) as B, sum(k)        over (partition by i order by j desc) as C, avg(k)     over (partition by i order by j desc) as D from t order by i, j, k;
select dense_rank()   over (partition by i order by j desc) as A, row_number() over (partition by i order by j desc) as B, stddev_pop(k) over (partition by i order by j desc) as C, var_pop(k) over (partition by i order by j desc) as D from t order by i, j, k;
select stddev_samp(k) over (partition by i order by j desc) as A, var_samp(k)  over (partition by i order by j desc) as B, count(k)      over (partition by i order by j desc) as C, rank()     over (partition by i order by j desc) as D from t order by i, j, k;

-- partition by i / order by j, k
select min(k)         over (partition by i order by j, k) as A, max(k)       over (partition by i order by j, k) as B, sum(k)        over (partition by i order by j, k) as C, avg(k)     over (partition by i order by j, k) as D from t order by i, j, k;
select dense_rank()   over (partition by i order by j, k) as A, row_number() over (partition by i order by j, k) as B, stddev_pop(k) over (partition by i order by j, k) as C, var_pop(k) over (partition by i order by j, k) as D from t order by i, j, k;
select stddev_samp(k) over (partition by i order by j, k) as A, var_samp(k)  over (partition by i order by j, k) as B, count(k)      over (partition by i order by j, k) as C, rank()     over (partition by i order by j, k) as D from t order by i, j, k;

-- partition by i / order by j, k desc
select min(k)         over (partition by i order by j, k desc) as A, max(k)       over (partition by i order by j, k desc) as B, sum(k)        over (partition by i order by j, k desc) as C, avg(k)     over (partition by i order by j, k desc) as D from t order by i, j, k;
select dense_rank()   over (partition by i order by j, k desc) as A, row_number() over (partition by i order by j, k desc) as B, stddev_pop(k) over (partition by i order by j, k desc) as C, var_pop(k) over (partition by i order by j, k desc) as D from t order by i, j, k;
select stddev_samp(k) over (partition by i order by j, k desc) as A, var_samp(k)  over (partition by i order by j, k desc) as B, count(k)      over (partition by i order by j, k desc) as C, rank()     over (partition by i order by j, k desc) as D from t order by i, j, k;

-- partition by i / order by i, k desc
select min(k)         over (partition by i order by i, k desc) as A, max(k)       over (partition by i order by i, k desc) as B, sum(k)        over (partition by i order by i, k desc) as C, avg(k)     over (partition by i order by i, k desc) as D from t order by i, j, k;
select dense_rank()   over (partition by i order by i, k desc) as A, row_number() over (partition by i order by i, k desc) as B, stddev_pop(k) over (partition by i order by i, k desc) as C, var_pop(k) over (partition by i order by i, k desc) as D from t order by i, j, k;
select stddev_samp(k) over (partition by i order by i, k desc) as A, var_samp(k)  over (partition by i order by i, k desc) as B, count(k)      over (partition by i order by i, k desc) as C, rank()     over (partition by i order by i, k desc) as D from t order by i, j, k;

drop table t;
