autocommit off;
( select shipment_pending, avg(product.price),
         max(product.price), min(product.price)
    from inventory_c i1
group by shipment_pending )
   union
( select shipment_pending, avg(product.price),
         max(product.price), min(product.price)
    from dated_inventory_c i2
group by shipment_pending );
rollback;
