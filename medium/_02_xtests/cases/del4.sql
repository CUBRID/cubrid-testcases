autocommit off;
select product.product_code, product.descr, product.price,
       quantity, location
  from inventory_c i;
delete from inventory_c
 where product.price * quantity > $1000000*20/10.0;
select product.product_code, product.descr, product.price,
       quantity, location
  from inventory_c i;
rollback work;
rollback;
