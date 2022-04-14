autocommit off;

select *
  from joe.shipment_c s
 where product.product_code = 3;
insert into joe.shipment_c(shipment_id, product, quantity, to_location)
values( 4,
        (select product_c
           from joe.product_c
          where product_code = 3),
        (3+2)*5,
        'milan');
select *
  from joe.shipment_c s
 where product.product_code = 3;
rollback work;
rollback;
