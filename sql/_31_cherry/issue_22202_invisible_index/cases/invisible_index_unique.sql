drop table if exists t1;
create table t1 ( 
    id    int primary key, 
    tid   int,
    unique key idx_tid(tid) invisible
);

drop table if exists t1;
create table t1 (
    id    int primary key,
    tid   int,
    unique key idx_tid(tid)
); 
alter index idx_tid on t1 invisible;

insert into t1 values (1, 2), (3, 4);
--err
insert into t1 values (5, 2);

insert into t1 values (5, 6), (7, 8), (9, 10);

select /*+ recompile */ * from t1 where tid=4;
--err
select /*+ recompile */ * from t1 force index(idx_tid) where tid=4;

alter index idx_tid on t1 visible;
select /*+ recompile */ * from t1 where tid=4;
select /*+ recompile */ * from t1 force index(idx_tid) where tid=4;

alter index idx_tid on t1 invisible;
select /*+ recompile */ * from t1 where tid=4;
select /*+ recompile */ * from t1 force index(idx_tid) where tid=4;

alter index idx_tid on t1 visible;
select /*+ recompile */ * from t1 where tid=4;
select /*+ recompile */ * from t1 force index(idx_tid) where tid=4;

alter index idx_tid on t1 invisible;
select /*+ recompile */ * from t1 where tid=4;
select /*+ recompile */ * from t1 force index(idx_tid) where tid=4;

drop table if exists t1;


