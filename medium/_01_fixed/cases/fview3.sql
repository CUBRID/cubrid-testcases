autocommit off;
select product_code, descr, d.location, name
  from joe.surplus_stock_v d, joe.employees_v e
 where d.location = e.location;
rollback;
