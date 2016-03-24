autocommit off;
  select shipment_id, product.product_code, quantity,
         to_location, original_loc
    from shipment_c s;
rollback;
