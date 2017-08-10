--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3,table({1,2,3,4,5,6,7,8,9,0}) t4;

create table t (i char(2), j int, k int, l int);

insert into t(i,j,k,l) select i+10, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select i+11, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select null, rownum,rownum,rownum from mille;


drop table mille;

create  unique index idx on t(i,j,k);


update statistics on all classes;
--test should use ISS
select /*+ recompile INDEX_SS */ * from t where j = 1 order by 1;

alter unique index idx on t(i,j,k) where i is not null rebuild;

update statistics on all classes;
select /*+ recompile INDEX_SS */ * from t where j = 1 order by 1;

alter unique index idx on t(i,j,k) rebuild;

update statistics on all classes;
select /*+ recompile INDEX_SS */ * from t where j = 1 order by 1;
alter unique index idx on t(i,k,l) rebuild;

update statistics on all classes;
select /*+ recompile  */ * from t where k = 1 order by 1;
alter unique index idx on t(i,j,k) where 1=1 rebuild;

update statistics on all classes;
select /*+ recompile INDEX_SS */ * from t where j = 1  using index idx order by 1;

alter unique index idx on t(i,j,k) where i >1 rebuild;

update statistics on all classes;
--test should not use ISS
select /*+ recompile INDEX_SS */ * from t where j = 1  using index idx order by 1;
drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
