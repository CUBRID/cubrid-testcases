drop table if exists t1;

create table t1(i int, j int) partition by range(i) (
partition p0 values less than (1),
partition p1 values less than (10),
partition p2 values less than (100),
partition p3 values less than MAXVALUE
);

insert into t1 values(-5,-5),(5,5),(15,15),(150,150);

Create unique index idx on t1(i,j) with online;

select /*+ RECOMPILE */ * from t1__p__p1 where i>0 and j>0;

drop t1;
