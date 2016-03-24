drop table if exists t;

create table t (i int, j int, k int);

create index i_t_ai on t(abs(i));

create index i_t_jia on t(i, abs(j));

create index i_t_ijk on t(i, j, abs(k));

create index i_t_i on t (i);

create index i_t_j on t (j) where j > 0;

create index i_t_2i idx on t(i);

create index i_t_2j on t(j) where j > 0;

create index i_t_3j on t(mod(i, 2));

create index idx4 on t(i, mod(j, 2));

create index idx5 on t(i, j, mod(k, 2));


show indexes from t;

insert into t values (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5);
insert into t values (10,1,1),(10,2,2),(10,3,3),(10,4,4),(10,5,5);
insert into t values (100,100,1),(100,100,2),(100,100,3),(100,100,4),(100,100,5);

select /*+ recompile */ * from t where abs(i) > 1;

select /*+ recompile */ * from t where i = 10 and abs(j) > 1;

select /*+ recompile */ * from t where i = 100 and j = 100 and abs(k) > 1;

select /*+ recompile */ * from t where mod(i,2 ) > 0;

select /*+ recompile */ * from t where i = 10 and mod(j, 2) > 0;

select /*+ recompile */ * from t where i = 100 and j = 100 and mod(k, 2) > 0;

select /*+ recompile */ * from t where i > 10 using index t.i_t_i(+);

select /*+ recompile */ * from t where j > 0 using index t.i_t_jia(+);

create table t2 like t;

show indexes from t2;

insert into t2 select * from t;

select /*+ recompile */ * from t2 where abs(i) > 1;

select /*+ recompile */ * from t2 where i = 10 and abs(j) > 1;

select /*+ recompile */ * from t2 where i = 100 and i = 100 and abs(k) > 1;

select /*+ recompile */ * from t2 where mod(i,2 ) > 0;

select /*+ recompile */ * from t2 where i = 10 and mod(j, 2) > 0;

select /*+ recompile */ * from t2 where i = 100 and j = 100 and mod(k, 2) > 0;

select /*+ recompile */ * from t2 where i > 10 using index t2.i_t_i(+);

select /*+ recompile */ * from t2 where j > 0 using index t2.i_t_jia(+);

drop index i_t_i on t;

drop index i_t_jia on t2;


drop table t, t2;