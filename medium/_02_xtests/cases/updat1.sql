autocommit off;
select shipment_id, product.product_code, quantity, to_location
  from joe.shipment_c s order by 1,2,3,4;
update joe.shipment_c
   set quantity = 100*2,
       to_location = 'capri'
 where product.product_code < 3;
select shipment_id, product.product_code, quantity, to_location
  from joe.shipment_c s order by 1,2,3,4;

rollback;
