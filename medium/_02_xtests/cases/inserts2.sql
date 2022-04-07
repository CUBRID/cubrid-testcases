autocommit off;
select product.product_code, product.descr, product.price,
       quantity, location
  from joe.inventory_c i
 where product.product_code = 8;
insert into joe.inventory_c(product, quantity, location)
values( (insert into joe.product_c(product_code, descr, price)
         values (8, 'thrusters', $1000000)),
        5,
        'milan');
select product.product_code, product.descr, product.price,
       quantity, location
  from joe.inventory_c i
 where product.product_code = 8;
rollback work;
rollback;
