autocommit off;
select product, quantity, location, shipment_pending
  from joe.inventory_c i
 where product.product_code > 5;
insert into joe.inventory_c (product, quantity, location, shipment_pending)
select product, quantity, location, shipment_pending
  from joe.inventory_c
 where product.product_code > 5;
select product, quantity, location, shipment_pending
  from joe.inventory_c i
 where product.product_code > 5;
rollback work;
rollback;
