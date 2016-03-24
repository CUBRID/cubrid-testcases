autocommit off;
select *
  from inventory_c i
 where product.product_code > 5;
insert into inventory_c (product, quantity, location, shipment_pending)
select *
  from inventory_c
 where product.product_code > 5;
select *
  from inventory_c i
 where product.product_code > 5;
rollback work;
rollback;
