autocommit off;
select product.product_code, product.descr, shipment_pending
from inventory_c i
where ( location = 'marseilles'
     or shipment_pending is null)
  and quantity > 1000;
rollback;
