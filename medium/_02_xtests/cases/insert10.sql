autocommit off;
select product, quantity, location, shipment_pending
  from inventory_c i
 where product.product_code > 5;
insert into inventory_c (product, quantity, location, shipment_pending)
select product, quantity, location, shipment_pending
  from inventory_c
 where product.product_code > 5;
select product, quantity, location, shipment_pending
  from inventory_c i
 where product.product_code > 5;
rollback work;
rollback;
