create table t (i int, j int, k int);
insert into t values (1, 1, 1);
insert into t values (1, 2, 2);
insert into t values (1, 3, 3);
insert into t values (2, 1, 1);
insert into t values (2, 2, 2);
insert into t values (3, 1, 1);
insert into t values (3, 2, 2);

-- no extra columns in select list
select /*+ recompile */ i, j, k, avg(k) over (partition by i order by j) from t order by 1, 2;
select /*+ recompile */ i, j, k, avg(k) over (partition by 1 order by 2) from t order by 1, 2;

-- one extra column in select list
select /*+ recompile */ i, k, avg(k) over (partition by i order by j) from t order by 1, 2;
select /*+ recompile */ i, k, avg(k) over (partition by 1 order by j) from t order by 1, 2;

select /*+ recompile */ j, k, avg(k) over (partition by i order by j) from t order by 1, 2;
select /*+ recompile */ j, k, avg(k) over (partition by i order by 1) from t order by 1, 2;

-- two extra columns in select list
select /*+ recompile */ avg(k) over (partition by i order by j) from t order by 1;

-- duplicate column, referenced more than once
select /*+ recompile */ avg(k) over (partition by i order by j asc, j asc, j asc) from t order by 1;
select /*+ recompile */ j, j, j, avg(k) over (partition by i order by 1 asc, 2 asc, 3 asc) from t order by 1, 2;

-- order by direction has priority over partition by direction
select /*+ recompile */ avg(k) over (partition by i asc order by i desc) from t order by 1;
select /*+ recompile */ avg(k) over (partition by i desc order by i asc) from t order by 1;
select /*+ recompile */ avg(k) over (partition by i desc, j asc order by i asc, j desc) from t order by 1;
select /*+ recompile */ avg(k) over (partition by i asc, i desc order by i asc) from t order by 1;

-- direction clashes
select /*+ recompile */ avg(k) over (partition by i order by j asc, j desc) from t order by 1;
select /*+ recompile */ j, i, j, avg(k) over (partition by i order by 1 asc, 3 desc) from t order by 1, 2;

drop t;

