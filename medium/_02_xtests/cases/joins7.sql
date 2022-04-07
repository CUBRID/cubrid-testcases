autocommit off;
select shipment_id, product.product_code, to_location, original_loc
  from joe.shipment_c s
 where product.product_code in (select product.product_code
                                  from joe.inventory_c
                                 union
                                select product.product_code
                                  from joe.dated_inventory_c) order by 1,2,3,4;
rollback;
