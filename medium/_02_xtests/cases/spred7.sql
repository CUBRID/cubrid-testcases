autocommit off;
  select product.product_code, product.descr, product.price,
         quantity, location, shipment_pending, expiry_date
    from joe.dated_inventory_c i;
rollback;
