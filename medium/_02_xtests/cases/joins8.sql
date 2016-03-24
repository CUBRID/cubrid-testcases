autocommit off;
  select i.product_code, descr, location,
         ((i.quantity - s.quantity)*price)
    from all inventory_v i, shipment_v s
   where i.location = s.origin
     and i.product_code = s.product_code
     and i.shipment_pending = 'yes'  order by 1,2,3;
rollback;
