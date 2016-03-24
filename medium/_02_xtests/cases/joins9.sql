autocommit off;
select product_code, descr, d.location, name
  from deficit_stock_v d, employees_v e
 where d.location = e.location  order by 1,2,3;
rollback;
