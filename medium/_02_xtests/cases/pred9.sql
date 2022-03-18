autocommit off;
  select i.product.product_code, i.product.descr, i.location,
         (i.quantity*i.product.price)
    from joe.inventory_c i
   where (i.shipment_pending = 'no'
          or i.shipment_pending is null);
rollback;
