drop table if exists t;

create table t(i int, j int) partition by range(i) (
partition p0 values less than (1),
partition p1 values less than (10),
partition p2 values less than (100),
partition p3 values less than MAXVALUE
);

Create unique index idx on t(i) with online;

select /*+ RECOMPILE */ * from t__p__p0 where i>0;

-- CBRD-22508
drop t;
