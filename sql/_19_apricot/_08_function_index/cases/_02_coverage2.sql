create table t2 (i int, d double);

create index idx on t2 (i) where i > 15;

create index idx2 on t2 (sqrt(d));

insert into t2 values (4,25), (16,256), (20,400);

select /*+ recompile */ * from t2 where sqrt(d) > 5;

select /*+ recompile */ * from t2 where i < 20 using index idx(+);

truncate table t2;

insert into t2 values (4,25), (16,256), (20,400);

select /*+ recompile */ * from t2 where sqrt(d) > 5;

select /*+ recompile */ * from t2 where i < 20 using index idx(+);

drop table t2;
