drop if exists sales;
create table sales(region varchar,product varchar,order_amt int);
insert into sales select 'china','china'||rownum,rownum from db_root connect by level<=1000;
insert into sales select 'china','hamberg'||rownum,rownum from db_root connect by level<=1000;
insert into sales select 'english','hamberg'||rownum,rownum+1000 from db_root connect by level<=1000;
insert into sales select 'english','music'||rownum,rownum+1000 from db_root connect by level<=1000;
WITH regional_sales AS (
       SELECT region
       ,      NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY
              region
       )
    SELECT region
   ,      total_sales
   FROM   regional_sales
   WHERE  total_sales > (SELECT SUM(total_sales)/3 AS one_third_sales
                         FROM   regional_sales);
drop if exists sales;
drop if exists t;
create table t(i int,j char(10));
insert into t values(1,'min');
insert into t values(3,'b');
insert into t values(6,'c');
insert into t values(9,'max');
insert into t values(null,null);
insert into t values(1000,'over');
with cte as (select * from t where i<1000 )
select * from cte where i >(select avg(i) from cte where j like 'min' or j like 'max') order by 1,2;
with cte as (select * from t where i<1000 )
select * from cte where i >(select min(i) from cte where j like 'min' or j like 'max') order by 1,2;
with cte as (select * from t where i<1000 )
select * from cte where i <(select max(i) from cte where j like 'min' or j like 'max') order by 1,2;
with avg_cte(avg_i) as (select avg(i) from t)
select * from t where i > (select avg_i from avg_cte);
with cte as (select * from t)
select * from t where i > any(select i from cte) order by 1,2;
with cte as (select * from t)
select * from cte where i between  (select min(i) from cte) and (select max(i) from cte) order by 1,2 ;
with cte as (select * from t)
select * from cte where i between  (select avg(i) from cte) and (select max(i) from cte) order by 1,2 ;
with cte as (select * from t)
select (select min(i) from cte) as min_v,(select max(i) from cte) as max_v,(select avg(i) from cte) as avg_v from cte where i between (select avg(i) from cte) and (select max(i) from cte) order by 1,2;
drop if exists t;


