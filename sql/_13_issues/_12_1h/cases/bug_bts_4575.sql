create table t1(a int)
PARTITION BY RANGE (a)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));
create index i_a on t1(a);

insert into t1 values (null);
insert into t1 values (7);
insert into t1 values (9);
insert into t1 values (8);
insert into t1 values (17);
insert into t1 values (19);
insert into t1 values (18);

select /*+ recompile */ * from t1 order by 1;
select /*+ recompile */ * from t1 where a is null order by 1;
select /*+ recompile */ * from t1 where a is not null order by 1;
select /*+ recompile */ * from t1 where a is null and a is not null order by 1;
select /*+ recompile */ * from t1 where a is null or a is not null order by 1;

alter table t1 reorganize partition before_10 into (partition before_0 values less than(0),partition before_10 values less than(10));
select /*+ recompile */ * from t1 order by 1;
select /*+ recompile */ * from t1 where a is null order by 1;
select /*+ recompile */ * from t1 where a is not null order by 1;
select /*+ recompile */ * from t1 where a is null and a is not null order by 1;
select /*+ recompile */ * from t1 where a is null or a is not null order by 1;

alter table t1 promote partition before_0;
insert into t1 values(NULL),(1);
insert into t1__p__before_0 values(NULL),(1);

select /*+ recompile */ * from t1 order by 1;
select /*+ recompile */ * from t1 where a is null order by 1;
select /*+ recompile */ * from t1 where a is not null order by 1;
select /*+ recompile */ * from t1 where a is null and a is not null order by 1;
select /*+ recompile */ * from t1 where a is null or a is not null order by 1;
select /*+ recompile */ * from t1__p__before_0 where a is null or a is not null order by 1;

alter table t1 add column j int;
update t1 set j=a;
update t1 set a= case when a is NULL then -1 else NULL end ;
select /*+ recompile */ * from t1 order by 2 desc;
select /*+ recompile */ * from t1 where a is null order by 2 desc;
select /*+ recompile */ * from t1 where a is not null order by 1;
select /*+ recompile */ * from t1 where a is null and a is not null order by 1;
select /*+ recompile */ * from t1 where a is null or a is not null order by 2;
select a,count(*)  from t1 group by a order by a; 

drop t1;
drop t1__p__before_0;




