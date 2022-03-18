autocommit off;
select shipment_id, product.product_code, to_location, original_loc
  from joe.shipment_c s
 where product.product_code > all (select product.product_code
                                     from joe.inventory_c i
                                    where product.product_code < 3
                                      and i.location = s.original_loc);
rollback;
