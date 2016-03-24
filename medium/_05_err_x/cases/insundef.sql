autocommit off;
select product.product_code
  from inventory_c
 where product_code > 5;

rollback;
