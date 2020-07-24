drop table if exists stores;
drop table if exists sales;
create table stores(
store_key varchar(4),
store_name varchar(40),
store_address varchar(40),
store_city varchar(20),
store_state varchar(2),
store_zip varchar(5)
);
create table sales(
store_key varchar(4),
book_key varchar(6),
order_number varchar(20),
order_date date,
quantity int
);
insert into sales values ('0001','000001','1','2017-01-20',500);
insert into sales values ('0003','000003','3','2017-01-20',800);
insert into sales values ('0012','000012','12','2017-01-20',700);

--insert into stores values ('0001','clothes','road 1','shanghai','00','430060');
--insert into stores values ('0002','food','road 2','wuhan','00','430061');
--insert into stores values ('0003','book','road 3','yunnan','01','430062');
--insert into stores values ('0012','pen','road 12','guangzhou','00','430064');
insert into stores values ('0001','clothes','road 1','shanghai','00','43006');
insert into stores values ('0002','food','road 2','wuhan','00','43006');
insert into stores values ('0003','book','road 3','yunnan','01','43006');
insert into stores values ('0012','pen','road 12','guangzhou','00','43006');


WITH
  sum_sales      AS
      (select sum(quantity) all_sales from sales),
  number_stores  AS
      (select count(*) nbr_stores from stores),
  sales_by_store AS
      (select store_name, sum(quantity) store_sales from stores s,sales s1 where s.store_key = s1.store_key group by store_name)
SELECT
   store_name
FROM
   stores,
   sum_sales,
   number_stores,
   sales_by_store
WHERE
   store_sales > (all_sales / nbr_stores)
;

WITH
  sum_sales      AS
      (select sum(quantity) all_sales from sales),
  number_stores  AS
      (select count(*) nbr_stores from stores),
  sales_by_store AS
      (select store_name, sum(quantity) store_sales from stores s,sales s1 where s.store_key = s1.store_key group by store_name)
SELECT
   stores.store_name
FROM
   stores,
   sum_sales,
   number_stores,
   sales_by_store
WHERE
   store_sales > (all_sales / nbr_stores)
order by stores.store_name;

with avg_sales(avg_sales) as (
select ((select sum(quantity) from sales)/(select count(*) from stores))
) ,
     single_sales (name,sales)as (
select store_name, sum(quantity) 
from stores s,sales s1
where s.store_key = s1.store_key  
group by store_name
)
select a.name,a.sales from single_sales a,avg_sales b where a.sales >b.avg_sales order by name, sales;
drop table if exists stores;
drop table if exists sales;
