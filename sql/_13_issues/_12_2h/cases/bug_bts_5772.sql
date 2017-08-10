create table t(i int unique) partition by list(i) (
        partition p0 values in (1, 2, 3),
        partition p1 values in (4, 5, 6),
        partition p2 values in (7, 8, 9),
        partition p3 values in (10, 11, 12)
      );
select /*+ RECOMPILE */ * from t where i>0;
select /*+ RECOMPILE */ * from t__p__p0 where i>0;
select /*+ RECOMPILE */ * from t__p__p1 where i>0;
select /*+ RECOMPILE */ * from t__p__p2 where i>0;
select /*+ RECOMPILE */ * from t__p__p3 where i>0;
drop table t;

create table t(i int, j int) partition by range(i) (
        partition p0 values less than (1),
        partition p1 values less than (10),
        partition p2 values less than (100),
        partition p3 values less than MAXVALUE
      );
Create unique index idx on t(i);
select /*+ RECOMPILE */ * from t where i>0;
select /*+ RECOMPILE */ * from t__p__p0 where i>0;
select /*+ RECOMPILE */ * from t__p__p1 where i>0;
select /*+ RECOMPILE */ * from t__p__p2 where i>0;
select /*+ RECOMPILE */ * from t__p__p3 where i>0;
drop table t;

CREATE TABLE t
( code CHAR(3) unique,

name VARCHAR(50) )

PARTITION BY HASH (code) PARTITIONS 4;


select /*+ RECOMPILE */ * from t where code>'';
select /*+ RECOMPILE */ * from t__p__p0 where code>'';
select /*+ RECOMPILE */ * from t__p__p1 where code>'';
select /*+ RECOMPILE */ * from t__p__p2 where code>'';
select /*+ RECOMPILE */ * from t__p__p3 where code>'';
drop table t;