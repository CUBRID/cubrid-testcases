-- 100000 records for each i: 0,1,2,3,4.
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3, table({1,2,3,4,5,6,7,8,9,0}) t4, table({0,1,2,3,4,5,6,7,8,9}) t5;

create table t (i int, j int, k int, l int);
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+5, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+6, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;

drop table mille;

create index idx on t(i,j,k);
select count (*) from t;

update statistics on all classes;

-- select EVERYTHING from ranges 1 ans 2
select /*+ recompile  */ count(*) from (select /*+ recompile index_ss NO_MERGE */ * from t where j between 151 and 199) tt;
-- create table answer as select /*+ recompile INDEX_SS */ i,j,k from t where j between 101 and 199;
-- select count(*) from answer;
-- drop table answer;

-- select EVERYTHING from ranges 0,3 and 4
select /*+ recompile  */ count(*) from (select /*+ recompile index_ss NO_MERGE */ * from t where j between 2 and 50) tt;
-- create table answer as select /*+ recompile INDEX_SS */ i,j,k from t where j between 2 and 100;
-- select count(*) from answer;
-- drop table answer;



drop table t;
