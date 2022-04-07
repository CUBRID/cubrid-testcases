autocommit off;
select product_code
  from all joe.inventory_v i
intersection
select product_code
  from joe.dated_inventory_v d
 where expiry_date > '10/10/92';
rollback;
