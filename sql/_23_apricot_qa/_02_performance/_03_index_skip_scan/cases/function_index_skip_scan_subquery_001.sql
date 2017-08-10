--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
-- 4000 records for each i: 0,1,2,3,4.
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3, table({0,1,2,3}) t4;

create table t (i int not null, j int, k int, l int);
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum,rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum,rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum,rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum,rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum,rownum from mille;

drop table mille;

create index idx on t(i,j,k);
--Test not use index
select count (*) from t ;

update statistics on all classes;

--Test not use index
select /*+ recompile INDEX_SS */ * from t where j = 100 order by 1;
--Test use ISS index idx
select /*+ recompile INDEX_SS */ * from t where j = 199 order by 1;
--Test not use index idx
select /*+ recompile INDEX_SS */ * from t where j = 199 and 1=0 order by 1;

--Test  use ISS index 
select /*+ recompile  */ count(*) from (select /*+ recompile INDEX_SS */ * from t where j between 101 and 199 ) tt;
--Test  mot use ISS index 
select /*+ recompile  */ count(*) from (select /*+ recompile INDEX_SS */ * from t where j between 101 and 199 ) tt;
--Test  not use ISS index 
select /*+ recompile */ i,j,k,l,(select /*+ recompile INDEX_SS */ count(*) from t where j between 101 and 199 ) from t order by 1;
--Test   use ISS index 
select /*+ recompile index_ss */ i,j,k,l,(select /*+ recompile INDEX_SS */ count(*) from t where j between 101 and 199 ) from t where j = 100 order by 1;
--Test  use ISS index 
select /*+ recompile index_ss  */ i,j,k,l,(select /*+ recompile INDEX_SS */ count(*) from t where j between 101 and 199 ) from t where j = 100  limit 1;
--Test  use ISS index 
select /*+ recompile index_ss */ i,j,k,l,(select /*+ recompile INDEX_SS */ count(*) from t where j between 101 and 199 ) from t where j = 100  limit 70,20;
--Test   use ISS index both subqeury and query
select /*+ recompile index_ss */ i,j,k,l,(select /*+ recompile INDEX_SS */ l from t where j between 101 and 199  limit 1) from t where j = 100 order by 1;
--Test not use index 
create table answer as select /*+ recompile INDEX_SS */ i,j,k from t where j between 101 and 199 ;
select count(*) from answer;
drop table answer;

--Test use ISS index idx
create table answer as select /*+ recompile INDEX_SS */ * from t where j between 101 and 199 ;
select count(*) from answer;
drop table answer;

--Test use ISS index idx
select /*+ recompile  */ count(*) from (select /*+ recompile INDEX_SS */ * from t where j between 2 and 100  limit 1) tt;

--Test use ISS index idx
create table answer as select /*+ recompile INDEX_SS */ i,j,k from t where j between 2 and 100 and l>0 ;
select count(*) from answer;
drop table answer;

--Test
insert into t values (0,100, 9999, 23);
--Test
insert into t values (1,199, 9999, 23);
--Test
insert into t values (2,199, 9999, 23);
--Test
insert into t values (3,100, 9999, 23);
--Test
insert into t values (4,100, 9999, 23);


---Test use ISS index idx
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS */ * from t where j between 101 and 199 ) tt;
--Test use ISS index idx
create table answer as select /*+ recompile INDEX_SS */ * from t where j between 101 and 199 ;
select count(*) from answer;
drop table answer;

--Test select EVERYTHING from ranges 0,3 and 4
select /*+ recompile  */ count(*) from (select /*+ recompile INDEX_SS */ * from t where j between 2 and 100 ) tt;
---Test use ISS index idx
create table answer as select /*+ recompile INDEX_SS */ * from t where j between 2 and 100 ;
select count(*) from answer;
drop table answer;

drop table t;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

