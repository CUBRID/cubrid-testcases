drop table if exists t;
create table t(a int, b int, c int, d int,e int);
create index i_t_abc on t(a,b,c);
update statistics on all classes;
set optimization level 513;
select /*+ recompile index_ss */ *  from t where a is not null and b>0 order by a;
drop t;

create table t(i int) partition by range(i)
(partition p1 values less than (1000),
 partition p2 values less than MAXVALUE
 );
 insert into t select rownum from db_root connect by level<=1000;
 create index idx on t(i);
 select /*+ recompile */ * from t where i=1000;
 drop t;
 create table t(i int,j int ) partition by range(i)
(partition p1 values less than (1),
 partition p2 values less than (2),
partition p3 values less than MAXVALUE
 );
 insert into t select rownum%3,rownum from db_root connect by level<=1000;
 create index idx on t(i,j);
 select /*+ recompile */ * from t where j=56;
 select /*+ recompile index_ss */ * from t where j=56;
 alter table t  promote partition p3;
 select /*+ recompile */ * from t where j=56;
 select /*+ recompile index_ss */ * from t where j=56;
 drop t;
 drop t__p__p3;

 create table t(i int,j int ) partition by range(i)
(partition p1 values less than (1001),
 partition p2 values less than MAXVALUE
 );
create index idx on t(i,j);
select /*+ recompile */ * from t where j<20 order by i limit 10;
select /*+ recompile index_ss  */ * from t where j<20 order by i limit 10;
insert into t select rownum,rownum%20 from db_root connect by level<=1000;
update statistics on all classes;
select /*+ recompile index_ss */ * from t where j<20 order by i limit 10;
select /*+ recompile index_ss */ * from t__p__p2 where j<20 order by i limit 10;
drop t;
