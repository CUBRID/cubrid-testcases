autocommit off;
select product_code, descr, d.location, name
  from surplus_stock_v d, employees_v e
 where d.location = e.location;
rollback;
