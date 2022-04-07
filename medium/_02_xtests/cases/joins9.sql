autocommit off;
select product_code, descr, d.location, name
  from joe.deficit_stock_v d, joe.employees_v e
 where d.location = e.location  order by 1,2,3;
rollback;
