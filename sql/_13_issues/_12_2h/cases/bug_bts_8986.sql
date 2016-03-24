create table t1(  a int, b int) PARTITION BY RANGE (a)  (
   PARTITION before_10 VALUES LESS THAN (10), 
   PARTITION before_20 VALUES LESS THAN (20)
);

insert into t1 values (3,5), (13,15);

create index idx on t1(b) where 1=1;

insert into t1 values (4,6),(14,16);

select /*+ recompile */ * from t1 where 1=1 using index idx (+);

select /*+ recompile */ * from t1__p__before_10 where 1=1 using index idx (+);

select /*+ recompile */ * from t1__p__before_20 where 1=1 using index idx (+);

drop table t1;
