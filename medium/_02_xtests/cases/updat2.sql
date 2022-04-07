autocommit off;
select product.product_code, product.descr, product.price,
       quantity, location
  from joe.inventory_c i
 where product.product_code > 5;
update joe.inventory_c
   set quantity = 25,
       location = 'milano'
 where product.product_code > 5;
select product.product_code, product.descr, product.price,
       quantity, location
  from joe.inventory_c i
 where product.product_code > 5;
rollback work;
rollback;
