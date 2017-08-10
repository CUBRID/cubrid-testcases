--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3;

create table t (i int, j int, k int, l int);

insert into t(i,j,k,l) select i+1, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select null, rownum,rownum,rownum from mille;


drop table mille;

create unique index idx on t(i,j,k);


update statistics on all classes;
--test should use ISS
select /*+ recompile INDEX_SS */ * from t where j = 1;
select /*+ recompile INDEX_SS */ * from t where j = any{1};


drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
