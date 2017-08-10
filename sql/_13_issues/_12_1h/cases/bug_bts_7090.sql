create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3, table({1,2,3,4,5,6,7,8,9,0}) t4;

create table t (i int, j int, k int, l int);

insert into t(i,j,k,l) select i+1, rownum,rownum,rownum from mille;

drop table mille;

create index idx on t(i,j,k);
select count (*) from t;

update statistics on all classes;
set optimization level 513;
--test should use ISS
select /*+ recompile INDEX_SS */ * from t where j = 1;
delete from t where j>999;
select count (*) from t;
update statistics on all classes;
--test should not use ISS
select /*+ recompile */ * from t where j = 1;
insert into t(i,j,k,l) value(2,1000,1000,1000) ;
update statistics on all classes;
--test should not use ISS
select /*+ recompile */ * from t where j = 1;
drop table t;


