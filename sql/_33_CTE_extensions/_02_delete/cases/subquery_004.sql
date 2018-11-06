drop if exists sales;
create table sales(region varchar,product varchar,order_amt int);
insert into sales select 'china','china'||rownum,rownum from db_root connect by level<=5;
insert into sales select 'china','hamberg'||rownum,rownum from db_root connect by level<=5;
insert into sales select 'english','hamberg'||rownum,rownum+100 from db_root connect by level<=6;
insert into sales select 'english','music'||rownum,rownum+100 from db_root connect by level<=6;
insert into sales select 'america','dance'||rownum,rownum from db_root connect by level<=7;

drop table if exists xx;
create table xx as
 WITH recursive regional_sales AS (
       SELECT region,NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY region
       ) select * from regional_sales;
select * from xx;

WITH recursive regional_sales AS (
       SELECT region,NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY region
       )
delete sales FROM sales,regional_sales
WHERE total_sales > (SELECT median(total_sales) AS one_third_sales FROM regional_sales) and sales.region=regional_sales.region;
 

update sales set order_amt=order_amt+10 where region in (
WITH recursive regional_sales AS (
       SELECT region,NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY region
       ) select region from regional_sales order by 1 limit 1
);
select * from sales order by 1,2,3;

WITH recursive regional_sales AS (
       SELECT region,NVL(max(order_amt),0) AS max_sales
       FROM   sales
       GROUP  BY region
       ) delete from sales where order_amt <> (select median(max_sales) from regional_sales);

select * from sales order by 1,2,3;    
drop if exists sales;
