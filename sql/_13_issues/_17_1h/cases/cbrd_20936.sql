--+ holdcas on;

drop table if exists t;

create table t (i1 varchar, i2 varchar);

create index i_t_123 on t(i1, i2);

insert into t values ('a', repeat('a',300));
insert into t values ('b', repeat('b',300));

select /*+ recompile */* from t where i1='a' order by i2 desc for orderby_num() between 1 and 3; 

select /*+ recompile */* from t where i1='a' order by i2 desc,i1 for orderby_num()=1;

select /*+ recompile */ i1,min(i2) from t where i1='a' and i2>'a' group by i2 having GROUPBY_NUM() between 1 and 2 order by i1;

select /*+ recompile */* from t where rownum between 1 and 2 and i1='a' order by i2 desc;

select * from t where i1='a' and rownum<10 group by i2 having GROUPBY_NUM()<10 order by i2 desc for orderby_num()>=1;

drop t;


drop table if exists t2;

create class t2(i1 varchar, i2 nchar varying,primary key(i1,i2)) partition by hash(i2) partitions 3;

insert into t2 values ('a', repeat(N'a',300));
insert into t2 values ('b', repeat(N'b',300));

select /*+ recompile */* from t2__p__p2 where i1='a' order by i2 desc for orderby_num() between 1 and 3; 

select /*+ recompile */* from t2__p__p2 where i1='a' order by i2 desc,i1 for orderby_num()=1;

select /*+ recompile */ i1,min(i2) from t2__p__p2 where i1='a' and i2>n'a' group by i2 having GROUPBY_NUM() between 1 and 2 order by i1;

select /*+ recompile */* from t2 where rownum between 1 and 2 and i1='a' order by i2 desc;

drop t2;

--+ holdcas off;