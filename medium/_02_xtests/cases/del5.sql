autocommit off;
select product.product_code, product.descr, quantity, expiry_date
  from dated_inventory_c d order by 1,2,3,4;
delete from dated_inventory_c
 where expiry_date < '1/1/1993';
select product.product_code, product.descr, quantity, expiry_date
  from dated_inventory_c d order by 1,2,3,4;
rollback work;

