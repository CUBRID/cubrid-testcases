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

alter table t change i a int;

update statistics on all classes;
select /*+ recompile INDEX_SS */ * from t where j = 1 order by 1;


drop unique index idx on t;

update statistics on all classes;
select /*+ recompile */ * from t where j = 1 order by 1;

alter table t add unique index idx(a,j,k);

update statistics on all classes;
select /*+ recompile INDEX_SS */ * from t where j = 1 order by 1;
alter table t drop COLUMN a;

update statistics on all classes;
select /*+ recompile */ * from t where j = 1 order by 1;
--test create faile
alter table t add unique index idx(j,k);
--test create successfully
alter table t add  index idx(j,k);
update statistics on all classes;
select /*+ recompile */ * from t where j = 1 order by 1;
drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
