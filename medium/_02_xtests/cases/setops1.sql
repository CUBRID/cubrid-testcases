autocommit off;
select product_code
  from inventory_v i
intersection
select product_code
  from dated_inventory_v d;
rollback;
