drop if exists t;
create table t (i int not null, j int, k int, l int, s string);
INSERT INTO t values (2,3,3876,1770,'H'), (0,9,982,1919,'J'), (2,3,4282,1453,'I'), (0,7,197,1679,'B'), (0,9,134,1909,'E'), (1,1,908,1293,'A'), (2,2,3772,1586,'F'), (1,6,111,1862,'D'), (0,6,2694,1908,'F'), (2,4,1238,1457,'G');
insert into t (i,j,k,l,s) select i,j,k,l+10000,s from t;
insert into t (i,j,k,l,s) select i,j,k,l+100000,s from t;
create index idx on t(i,j,k,l);
update statistics on all classes;
WITH cte_E6H4opTTz AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, j desc
)
,cte_ZMXRwH3sE AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, j desc
)
,
cte_RyHstqnFm AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, j desc
)
select * from cte_E6H4opTTz,cte_ZMXRwH3sE,cte_RyHstqnFm order by 1 limit 10;

-- iss, but no skip order by
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, j asc, k asc;


WITH cte_rZJ9v6Ljh AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, k asc
)
,cte_xdAvJG39f AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, k asc
)
,
cte_EIZ7LzaTY AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, k asc
)
select * from cte_rZJ9v6Ljh,cte_xdAvJG39f,cte_EIZ7LzaTY order by 1 limit 10;

-- skip order by again:
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 1000 order by i desc, k desc;

drop index idx on t;
create index idx on t(i asc,j desc,k desc,l asc);
update statistics on all classes;
select * from t;
drop table t;
commit;
drop if exists t;
