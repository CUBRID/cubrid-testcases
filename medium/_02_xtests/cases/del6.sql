autocommit off;
select product.product_code, product.descr, quantity, expiry_date
  from dated_inventory_c d order by 1,2,3,4;
delete from dated_inventory_c
 where product.product_code > 2
   and expiry_date > '12/31/1992';
select product.product_code, product.descr, quantity, expiry_date
  from dated_inventory_c d order by 1,2,3,4;

rollback;
