create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3;

create table t (i char(2), j int, k int, l int);

insert into t(i,j,k,l) select i, rownum,rownum,rownum from mille;

insert into t(i,j,k,l) select i+1, rownum,rownum,rownum from mille;

insert into t(i,j,k,l) select null, rownum,rownum,rownum from mille;

drop table mille;

create   index idx on t(i,j,k);

update statistics on all classes;

select /*+ recompile INDEX_SS */ * from t where j = 1 order by 1;

alter  index idx on t(i,j,k) where i >1 rebuild;

select /*+ recompile INDEX_SS */ * from t where j = 1  using index idx order by 1;

select /*+ recompile INDEX_SS */ * from t where j = 1  order by 1;

drop table t;


