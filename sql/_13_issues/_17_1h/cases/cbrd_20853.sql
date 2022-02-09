drop table if exists t;
create table t(i int,b char(500) default 'a');
insert into t(i)
(
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=60
)select n1 from cte1
);
insert into t(i)
(
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=60
)select n1 from cte1
);

insert into t(i)
(
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=60000
)select n1 from cte1
);

insert into t(i)
(
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=60000
)select n1 from cte1
);
insert into t(i)
(
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=60000
)select n1 from cte1
);
insert into t(i)
(
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=6
)select n1 from cte1
);
with cte2 as (select sum(i) from t ) select * from cte2;
insert into t(i)
(
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=30
)select n1 from cte1
);
with cte2 as (select sum(i) from t ) select * from cte2 select * from cte2 select * from cte2;
with cte2 as (select i from t ) select * from cte2 order by 1 desc  limit 1;
with cte2 as (select sum(i) from t ) select * from cte2;
with cte2 as (select sum(i) from t )
,cte3 as (select sum(i) from t )
,cte4 as (select sum(i) from t )
,cte5 as (select sum(i) from t )
,cte6 as (select sum(i) from t ) select * from cte6;

with cte2 as (select i from t )
,cte3 as (select i from t )
,cte4 as (select i from t )
,cte5 as (select i from t )
,cte6 as (select i from t ) select count(*) from cte6 order by 1 desc  limit 1;

with cte2 as (select i from t )
,cte3 as (select i from t )
,cte4 as (select i from t )
,cte5 as (select i from t )
,cte6 as (select i from t ) select sum(i) from cte6 order by 1 desc  limit 1;
drop table if exists t;                  