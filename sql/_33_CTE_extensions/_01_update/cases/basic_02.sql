drop if exists sales;
create table sales(region varchar,product varchar,order_amt int);
insert into sales select 'china','china'||rownum,rownum from db_root connect by level<=5;
insert into sales select 'china','hamberg'||rownum,rownum from db_root connect by level<=5;
insert into sales select 'english','hamberg'||rownum,rownum from db_root connect by level<=5;
insert into sales select 'english','music'||rownum,rownum from db_root connect by level<=5;
drop table if exists xoo;
create table xoo as select * from sales;

WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY
              region
       )
update sales set order_amt=order_amt-(SELECT avg(total_sales) FROM regional_sales);

select * from sales;
delete from sales;

insert into sales select * from xoo;
WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY
              region
               )
update sales set order_amt=order_amt-(SELECT total_sales FROM regional_sales where region=sales.region);

select * from sales;
delete from sales;


insert into sales select * from xoo;
WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY
              region
)
update sales,regional_sales set order_amt=order_amt-total_sales where sales.region = regional_sales.region;
select * from sales;
delete from sales;



insert into sales select * from xoo;
WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(avg(order_amt),0) AS avg_sales
       FROM   sales
       GROUP  BY
              region
        )
update sales set order_amt=order_amt+28 
where region in (select region from regional_sales where avg_sales >sales.order_amt);


select * from sales;
delete from sales;



insert into sales select * from xoo;
WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(avg(order_amt),0) AS avg_sales
       FROM   sales
       GROUP  BY
              region
                )
update sales set order_amt=order_amt+28
where region=some(select region from regional_sales where avg_sales >sales.order_amt);

select * from sales;
delete from sales;


insert into sales select * from xoo;
WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(avg(order_amt),0) AS avg_sales
       FROM   sales
       GROUP  BY
              region
                        )
update sales set order_amt=order_amt+28
where region=any(select region from regional_sales where avg_sales >sales.order_amt);

select * from sales;
delete from sales;

insert into sales select * from xoo;
WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(avg(order_amt),0) AS avg_sales
       FROM   sales
       GROUP  BY
              region
                        )
update sales set order_amt=order_amt+28
where region=all(select region from regional_sales where avg_sales >sales.order_amt);

select * from sales;
delete from sales;


drop if exists sales;
