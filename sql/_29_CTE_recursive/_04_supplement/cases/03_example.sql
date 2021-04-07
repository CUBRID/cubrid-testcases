drop if exists t;
create table t (i int not null, j int, k int, l int, s string);
INSERT INTO t values (0,3,4225,1291,'H'), (0,4,893,1280,'K'), (1,10,1403,1978,'G'), (2,3,3096,1001,'H'), (2,7,4390,1459,'G'), (2,2,1190,1594,'B'), (1,10,4560,1291,'J'), (1,3,616,1419,'B'), (1,6,1026,1724,'C'), (0,9,1152,1644,'E');
INSERT INTO t values (0,9,2839,1794,'F'), (1,2,917,1547,'G'), (1,10,4961,1761,'B'), (1,9,3894,1168,'F'), (1,5,3762,1820,'K'), (2,7,4937,1671,'H'), (2,9,4406,1045,'E'), (2,2,4644,1442,'A'), (0,8,950,1400,'J'), (2,7,2066,1055,'C');
insert into t (i,j,k,l,s) select i,j,k,l+10000,s from t;
insert into t (i,j,k,l,s) select i,j,k,l+100000,s from t;
create index idx on t(i,j,k,l);
update statistics on all classes;
-- range and key filter, index must cover, otherwise optimizer would select sscan.
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and l > 1800;
-- no key filter, only range
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000;

-- no key filter, only range, with order by criteria
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i;

-- use descending index: the simple case
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc;

-- still skip order by, regardless of j's orientation, because j is cosntant (=10) 
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, j asc;
WITH cte_E6H4opTTz AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, j desc
)
,cte_ZMXRwH3sE AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, j desc
)
,
cte_RyHstqnFm AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, j desc
)
select * from cte_E6H4opTTz,cte_ZMXRwH3sE,cte_RyHstqnFm order by 1 limit 10;

-- iss, but no skip order by
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, j asc, k asc;


WITH cte_rZJ9v6Ljh AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, k asc
)
,cte_xdAvJG39f AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, k asc
)
,
cte_EIZ7LzaTY AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, k asc
)
select * from cte_rZJ9v6Ljh,cte_xdAvJG39f,cte_EIZ7LzaTY order by 1 limit 10;

-- skip order by again:
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 10 and k > 4000 order by i desc, k desc;

drop index idx on t;
create index idx on t(i asc,j desc,k desc,l asc);
update statistics on all classes;

WITH cte_LKITbOKfi AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j >= 9
)
,cte_2HIavrDHB AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j >= 9
)
,
cte_MmPLfaJHi AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j >= 9
)
select * from cte_LKITbOKfi,cte_2HIavrDHB,cte_MmPLfaJHi order by 1 limit 10;
WITH cte_5CF0gJbeT AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j >= 9 and k > 4000
)
,cte_WEwSnJA3L AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j >= 9 and k > 4000
)
,
cte_aub0aLIzL AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j >= 9 and k > 4000
)
select * from cte_5CF0gJbeT,cte_WEwSnJA3L,cte_aub0aLIzL order by 1 limit 10;
WITH cte_r0qnBAIpz AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3) and l between 1063 and 1064
)
,cte_O7KqkzGCb AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3) and l between 1063 and 1064
)
,
cte_0SighCiby AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3) and l between 1063 and 1064
)
select * from cte_r0qnBAIpz,cte_O7KqkzGCb,cte_0SighCiby order by 1 limit 10;
WITH cte_Z9rP4M8V3 AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3) and l between 1063 and 1080 and i <> 0
)
,cte_iCFuHl37Q AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3) and l between 1063 and 1080 and i <> 0
)
,
cte_6SNnS5HNA AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3) and l between 1063 and 1080 and i <> 0
)
select * from cte_Z9rP4M8V3,cte_iCFuHl37Q,cte_6SNnS5HNA order by 1 limit 10;
WITH cte_vtAsbWpBu AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3)
)
,cte_C7bDlr3hP AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3)
)
,
cte_gamBmQ3L1 AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where (j = 2 or j = 3)
)
select * from cte_vtAsbWpBu,cte_C7bDlr3hP,cte_gamBmQ3L1 order by 1 limit 10;

-- this one has a bigger selectivity and thus yields a sscan (!)
select /*+ recompile */ count(*) from (select /*+ recompile INDEX_SS */ i,j,k,l from t where (j < 2 or j > 3)) tt;

WITH cte_VQ7yS0XHQ AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where i is not null and j = 2 and k = 1001
)
,cte_2ZQcXDAdA AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where i is not null and j = 2 and k = 1001
)
,
cte_3eZUzGwXo AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where i is not null and j = 2 and k = 1001
)
select * from cte_VQ7yS0XHQ,cte_2ZQcXDAdA,cte_3eZUzGwXo order by 1 limit 10;
WITH cte_WxQZy76Ma AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 2 and k = 1001 and (l = 3 or l > 5)
)
,cte_BrMiSZiv0 AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 2 and k = 1001 and (l = 3 or l > 5)
)
,
cte_XB6X5mAZX AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j = 2 and k = 1001 and (l = 3 or l > 5)
)
select * from cte_WxQZy76Ma,cte_BrMiSZiv0,cte_XB6X5mAZX order by 1;


WITH cte_Fy3YOYnpy AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where i > 2
)
,cte_NgBNjLROe AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where i > 2
)
select * from cte_Fy3YOYnpy,cte_NgBNjLROe order by 1 limit 10;
WITH cte_Gwrn14Rz8 AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j <> 2 order by i,j,k,l limit 10
)
,cte_ef4TXC0xH AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j <> 2 order by i,j,k,l limit 10
)
select * from cte_Gwrn14Rz8,cte_ef4TXC0xH order by 1 limit 10;
WITH cte_vpBtw1O1e AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j is not null and l = 1001
)
,cte_IB1YDM4bs AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j is not null and l = 1001
)
,
cte_XFluxeWjy AS 
(
select /*+ recompile INDEX_SS */ i,j,k,l from t where j is not null and l = 1001
)
select * from cte_vpBtw1O1e,cte_IB1YDM4bs,cte_XFluxeWjy order by 1 limit 10;


drop table t;
commit;
