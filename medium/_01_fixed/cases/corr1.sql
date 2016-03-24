autocommit off;
select shipment_id, y.product_code, to_location, original_loc
  from shipment_c s, product_c y
 where product= y and y.product_code in (select product.product_code
                                  from inventory_c i1
                                 where i1.location = s.original_loc
                                 union
                                select product.product_code
                                  from dated_inventory_c i2
                                 where i2.location = s.original_loc)
order by shipment_id, y.product_code, to_location, original_loc;
rollback;
