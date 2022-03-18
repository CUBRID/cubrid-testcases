autocommit off;
select product_code
  from joe.inventory_v i
intersection
select product_code
  from joe.dated_inventory_v d;
rollback;
