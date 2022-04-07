autocommit off;
select shipment_id, y.product_code, to_location, original_loc
  from joe.shipment_c s, joe.product_c y
 where product= y and y.product_code in (select product.product_code
                                  from joe.inventory_c i1
                                 where i1.location = s.original_loc
                                 union
                                select product.product_code
                                  from joe.dated_inventory_c i2
                                 where i2.location = s.original_loc)
order by shipment_id, y.product_code, to_location, original_loc;
rollback;
