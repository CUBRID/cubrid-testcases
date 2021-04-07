--+ holdcas on;
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3,table({1,2,3,4,5,6,7,8,9,0}) t4;

create table t (i int, j int, k int, l int)
PARTITION BY RANGE (i)
(PARTITION before_2 VALUES LESS THAN (2),
PARTITION before_1005 VALUES LESS THAN (1005));

insert into t(i,j,k,l) select i+1, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select i, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select null, rownum,rownum,rownum from mille;
insert into t(i,j,k,l) select rownum+3, rownum,rownum,rownum from mille;


drop table mille;

create  index idx on t(i,j,k);


update statistics on all classes;
commit;
--test should use ISS
select /*+ recompile INDEX_SS */ * from t where j = 1 order by 1;
select /*+ recompile INDEX_SS */ * from t__p__before_2 where j = 1 order by 1;
select /*+ recompile INDEX_SS */ * from t__p__before_1005 where j = 1 order by 1;


drop table t;
commit;
--+ holdcas off;
