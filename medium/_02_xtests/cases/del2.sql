autocommit off;
select product.product_code, product.descr, product.price,
       quantity, location
  from joe.inventory_c i;
delete from joe.inventory_c
 where product.product_code > 5;
select product.product_code, product.descr, product.price,
       quantity, location
  from joe.inventory_c i;
rollback work;
rollback;
