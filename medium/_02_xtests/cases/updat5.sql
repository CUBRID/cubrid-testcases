autocommit off;
select product.product_code, product.descr, quantity, expiry_date
  from dated_inventory_c d
 where product.product_code = 4;
update dated_inventory_c
   set quantity = 10,
       expiry_date = NULL
 where product.product_code = 4;
select product.product_code, product.descr, quantity, expiry_date
  from dated_inventory_c d
 where product.product_code = 4;
rollback work;
rollback;
