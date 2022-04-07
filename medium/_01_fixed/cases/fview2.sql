autocommit off;
 select i.product_code, descr, location,
        ((i.quantity - s.quantity)*price)
   from all joe.inventory_v i, joe.shipment_v s
  where i.location = s.origin
    and i.product_code = s.product_code
    and i.shipment_pending = 'yes';
rollback;
