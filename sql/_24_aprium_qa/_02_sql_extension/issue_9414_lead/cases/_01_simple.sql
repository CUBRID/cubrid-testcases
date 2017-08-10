-- create and populate table
create table t (i int, j int);
insert into t values (1, 1);
insert into t values (2, 1);
insert into t values (3, 1);
insert into t values (4, 1);
insert into t values (5, 1);
insert into t values (6, 2);
insert into t values (7, 2);
insert into t values (8, 2);
insert into t values (9, 3);
insert into t values (10, 3);

-- simple, order by
select i, j, lead (i) over (order by i) from t;
select i, j, lead (i, 3) over (order by i) from t;
select i, j, lead (i, 3, -1) over (order by i) from t;

select i, j, lag (i) over (order by i) from t;
select i, j, lag (i, 3) over (order by i) from t;
select i, j, lag (i, 3, -1) over (order by i) from t;

-- simple, order by x 2
select i, j, lead (i) over (order by j desc, i) from t;
select i, j, lead (i, 3) over (order by  j desc, i) from t;
select i, j, lead (i, 3, -1) over (order by  j desc, i) from t;

select i, j, lag (i) over (order by  j desc, i) from t;
select i, j, lag (i, 3) over (order by  j desc, i) from t;
select i, j, lag (i, 3, -1) over (order by  j desc, i) from t;

-- simple, order by + partition by
select i, j, lead (i) over (partition by j order by i) from t;
select i, j, lead (i, 3) over (partition by j order by i) from t;
select i, j, lead (i, 3, -1) over (partition by j order by i) from t;

select i, j, lag (i) over (partition by j order by i) from t;
select i, j, lag (i, 3) over (partition by j order by i) from t;
select i, j, lag (i, 3, -1) over (partition by j order by i) from t;

-- two functions, same partitioning
select lag(i) over (partition by j order by i), i, j, lead(i) over (partition by j order by i) from t;
select lag(i, 2) over (partition by j order by i), i, j, lead(i, 2) over (partition by j order by i) from t;
select lag(i, 2, -1) over (partition by j order by i), i, j, lead(i, 2, -1) over (partition by j order by i) from t;

-- two functions, different partitioning
select lag(i) over (order by i), i, j, lead(i) over (partition by j order by i) from t;
select lag(i, 2) over (order by i), i, j, lead(i, 2) over (partition by j order by i) from t;
select lag(i, 2, -1) over (order by i), i, j, lead(i, 2, -1) over (partition by j order by i) from t;

-- two functions, different ordering
select lag(i) over (partition by j order by i desc), i, j, lead(i) over (partition by j order by i) from t;
select lag(i, 2) over (partition by j order by i desc), i, j, lead(i, 2) over (partition by j order by i) from t;
select lag(i, 2, -1) over (partition by j order by i desc), i, j, lead(i, 2, -1) over (partition by j order by i) from t;

-- cleanup
drop table t;
