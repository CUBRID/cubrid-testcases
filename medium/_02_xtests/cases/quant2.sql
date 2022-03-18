autocommit off;
select *
  from joe.inventory_c i
 where product.product_code > some
       (select product.product_code
          from joe.shipment_c
         where product.product_code in
               (select product.product_code
                from joe.dated_inventory_c));
rollback;
