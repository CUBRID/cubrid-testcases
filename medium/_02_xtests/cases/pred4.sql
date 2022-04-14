autocommit off;
select product.product_code, product.descr, shipment_pending
  from joe.inventory_c i
 where location = 'marseilles'
    or shipment_pending is null;
rollback;
