drop table if exists t;
create table t (i int, j int);

create index idx on t (i);

insert into t values (1, 1);
insert into t values (1, 2);
insert into t values (1, 3);
insert into t values (2, 1);
insert into t values (2, 2);
insert into t values (2, 3);
insert into t values (3, 1);
insert into t values (3, 2);
insert into t values (3, 3);
insert into t values (4, 1);
insert into t values (4, 2);
insert into t values (4, 3);
insert into t values (5, 1);
insert into t values (5, 2);
insert into t values (5, 3);
insert into t values (6, 1);
insert into t values (6, 2);
insert into t values (6, 3);
insert into t values (7, 1);
insert into t values (7, 2);
insert into t values (7, 3);
insert into t values (8, 1);
insert into t values (8, 2);
insert into t values (8, 3);
insert into t values (9, 1);
insert into t values (9, 2);
insert into t values (9, 3);
insert into t values (10, 1);
insert into t values (10, 2);
insert into t values (10, 3);


select /*+ recompile */ i,j from t where i > -5 group by i limit 4;

select /*+ recompile */ i,j from t where i > -5 group by i limit 2,4;

select /*+ recompile */ i,j from t where i > -5 group by i limit 100;

select /*+ recompile */ i,j from t where i > -5 group by i having j > 0 limit 4;

select /*+ recompile */ i,j from t where i > -5 group by i having j > 0 limit 2,4;

select /*+ recompile */ i,j from t where i > -5 group by i having j > 0 limit 100;

select /*+ recompile */ i,j from t where i > -5 group by i having avg(j) > 0 limit 4;

select /*+ recompile */ i,j from t where i > -5 group by i having avg(j) > 0 limit 2,4;

select /*+ recompile */ i,j from t where i > -5 group by i having avg(j) > 0 limit 100;

select /*+ recompile */ i,j from t where i > -5 group by i having avg(j) > 3 limit 4;

select /*+ recompile */ i,j from t where i > -5 group by i having avg(j) > 3 limit 2,4;

select /*+ recompile */ i,j from t where i > -5 group by i having avg(j) > 3 limit 100;

drop table t;

