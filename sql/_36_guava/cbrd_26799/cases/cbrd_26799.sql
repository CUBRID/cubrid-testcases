-- CBRD-26799 parallel CREATE INDEX row loss.
-- Before: index dropped ~1 heap page (heap OK, INDEX_SS short).
-- After: INDEX_SS count == heap.
-- Check: 2.1M rows, rebuild x10, count via INDEX_SS.
--
-- Note: 2.1M rows (> 2048 heap pages) make plain CREATE INDEX use the parallel
-- build path (700K would run serial). t is dropped at end for CI file independence.


-- setup: load 2.1M rows
create table mille as select 0 as i from table({1,2,3,4,5,6,7,8,9,0}) t1, table({1,2,3,4,5,6,7,8,9,0}) t2, table({1,2,3,4,5,6,7,8,9,0}) t3, table({1,2,3,4,5,6,7,8,9,0}) t4, table({0,1,2,3,4,5,6,7,8,9}) t5;
create table t (i int not null, j int, k int, l int);
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+5, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+6, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+5, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+6, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+2, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+5, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+6, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+1, 2*((rownum-1)%50+1)-1+100,rownum, rownum from mille;
insert into t(i,j,k,l) select i+0, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+3, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
insert into t(i,j,k,l) select i+4, 2*((rownum-1)%50+1)  ,rownum, rownum from mille;
drop table mille;

-- heap scan (reference count)
select count(*) from t;


-- iteration 1/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
--@queryplan
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
--@queryplan
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 2/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 3/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 4/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 5/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 6/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 7/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 8/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 9/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- iteration 10/10: rebuild index (parallel), count via INDEX_SS
create index idx on t(i,j,k);
update statistics on t;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 151 and 199) tt;
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS NO_MERGE */ * from t where j between 2 and 50) tt;
drop index idx on t;

-- cleanup (file independence)
drop table t;
