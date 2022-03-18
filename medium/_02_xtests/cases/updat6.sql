autocommit off;
select product.product_code, product.descr, quantity, expiry_date
  from joe.dated_inventory_c d
 where product.product_code = 4;
update joe.dated_inventory_c
   set quantity = 10,
       expiry_date = '9/9/1992'
 where product.product_code = 4;
select product.product_code, product.descr, quantity, expiry_date
  from joe.dated_inventory_c d
 where product.product_code = 4;
rollback work;
rollback;
