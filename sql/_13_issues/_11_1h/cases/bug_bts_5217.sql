create table t(i1 int, i2 int, i3 int);

create index i_t_123 on t(i1,i2,i3);


select /*+ recompile */ * from t where i1 in (0) and i2=0 order by i3 for orderby_num()<4;

drop index i_t_123 on t;

drop table t;
