autocommit off;

select shipment_id, product.product_code, quantity, to_location
  from shipment_c s
 where product.product_code = 3;
insert into shipment_c(shipment_id, product, quantity, to_location)
values( (select max(shipment_id)+1
           from shipment_c),
        (select product_c
           from product_c
          where product_code = 3),
        15,
        'milan');
select shipment_id, product.product_code, quantity, to_location
  from shipment_c s
 where product.product_code = 3;
rollback work;
rollback;
