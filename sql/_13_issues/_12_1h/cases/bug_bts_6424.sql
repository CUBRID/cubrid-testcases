drop table if exists t1;
create table t1 (a int, b int, c int, d int);
create index i1_a on t1(a);
create index i1_ab on t1(a, b);
set optimization level 257;

insert into t1 values (1,1,1,1), (2,2,2,2);

select /*+ recompile */ * from t1 where a>0;
select /*+ recompile */ * from t1 where a>0 order by b;

drop table if exists t1;
create table t1 (a int, b int, c int, d int);
create index i1_ab on t1(a, b);
create index i1_a on t1(a);

insert into t1 values (1,1,1,1), (2,2,2,2);

select /*+ recompile */ * from t1 where a>0;
select /*+ recompile */ * from t1 where a>0 order by b;

drop table t1;
