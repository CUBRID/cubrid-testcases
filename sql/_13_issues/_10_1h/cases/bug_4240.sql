create table t1 (col1 decimal(6,5),col2 int);
insert into t1 values (1.001, 1);
insert into t1 values (2.001, 2);

select /*+ recompile */ * from t1 where  col1> 1.001;

create index i_t1_all on t1(col1,col2);

select /*+ recompile */ * from t1 where  col1> 1.001;

drop table t1;

