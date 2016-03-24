autocommit off;
select *
  from inventory_c i
 where product.product_code > some
       (select product.product_code
          from shipment_c
         where product.product_code in
               (select product.product_code
                from dated_inventory_c));
rollback;
