autocommit off;
select product_code
  from all inventory_v i
intersection
select product_code
  from dated_inventory_v d
 where expiry_date > '10/10/92';
rollback;
