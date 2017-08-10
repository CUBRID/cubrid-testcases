create table t (i1 int, i2 int, i3 int);
create index i_t_123 on t(i1, i2, i3);

select /*+ recompile */ * from t where i1=4 and i2 in (i1);

drop table t;

