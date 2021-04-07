--+ holdcas on;
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

--Test use ISS index idx
select /*+ recompile INDEX_SS */ * from t where j = 199 ;
--Test use ISS index idx
select /*+ recompile INDEX_SS */ * from t where j = 199 and exists(select i) ;
--Test use ISS index idx
select /*+ recompile INDEX_SS */ * from t where j = 199 and exists(select l) ;
--Test use ISS index idx
select /*+ recompile index_ss */ * from t where j = 199 and exists(select /*+ recompile INDEX_SS */ l from t where j = 199 ) ;


drop table t;
commit;
--+ holdcas off;



