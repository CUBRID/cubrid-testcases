--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3,table({1,2,3,4,5,6,7,8,9,0}) t4;

create table t (i char(2), j int, k int, l int);

insert into t(i,j,k,l) select i+10, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select i+11, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select null, rownum,rownum,rownum from mille;


drop table mille;

create  index idx on t(i(1),j,k);


update statistics on all classes;
--test should use ISS
select /*+ recompile */ * from t where j = 1 order by 1;
select /*+ recompile */ * from t where j = any{1} order by 1;
select /*+ recompile */ * from t where j = any{1} and i is null order by i;
select /*+ recompile */ * from t where j = any{1} and i is not null order by 1;;

select /*+ recompile */ * from t where j = any{1} and i is null order by i desc;


drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;