drop if exists t;
create table t(id int);
insert into t values(1);
with cte as (
select 1 as id
union all
select cte.* from t
inner join cte on t.id=cte.id
)select * from cte order by 1;

with cte as (
select 1 as id
union all
select cte.id from t
inner join cte on t.id=cte.id
)select * from cte order by 1;

with cte as (
select 1 as c1
union all
select cte.* from t
inner join cte on t.id=cte.c1
)select * from cte order by 1;

with cte as (
select 1 as c1
union all
select cte.c1 from t
inner join cte on t.id=cte.c1
)select * from cte order by 1;

with cte as (
select 1 as id
union all
select cte.*+1 from t
inner join cte on t.id=cte.id
)select * from cte order by 1;

with cte as (
select 1 as id
union all
select cte.id+1 from t
inner join cte on t.id=cte.id
)select * from cte order by 1;
drop if exists t;

WITH MyCTE(Number) AS(
SELECT 1 AS Number 
UNION ALL  
SELECT count(R.Number + 1) 
FROM MyCTE AS R group by R.Number having count(R.Number) <2000
) 
SELECT Number 
FROM MyCTE ;


WITH MyCTE(Number,col2) AS(                                                                                                                                            
SELECT 1 AS Number,'a' as col2
UNION ALL 
SELECT R.Number + 1,'b' 
FROM MyCTE AS R group by R.Number having R.Number <5
)
SELECT Number ,col2                                                                                                                              
FROM MyCTE order by 1,2 ;

WITH MyCTE(Number,col2) AS(                                                                                                                                            
SELECT 1 AS Number,'a' as col2
UNION ALL 
SELECT R.Number + 1,'b' 
FROM MyCTE AS R group by R.col2 having count(R.Number) <5
)
SELECT Number ,col2                                                                                                                              
FROM MyCTE order by 1,2 ;

drop if exists t1;
create table t1(i int auto_increment);
insert into t1 values(1);
WITH MyCTE(Number,col2) AS(                                                                                                                                            
SELECT 1 AS Number,'a' as col2
UNION ALL 
SELECT t1.i,'b' 
FROM MyCTE AS R,t1 group by R.col2 having count(R.Number) <5
)
SELECT Number ,col2                                                                                                                              
FROM MyCTE order by 1,2 ;

WITH MyCTE(Number,col2) AS(

SELECT 1 AS Number,'a' as col2
UNION ALL
SELECT t1.i,'b'
FROM t1
)
SELECT Number ,col2
FROM MyCTE order by 1,2 ;

drop if exists t1;
