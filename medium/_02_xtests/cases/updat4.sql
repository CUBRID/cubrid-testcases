autocommit off;
select *
  from product_c p
 where product_code > 6;
update product_c
   set descr = 'rainbow colored magic unicorn thrusters',
       price = $1000000*3/4
 where product_code = 7;
select *
  from product_c p
 where product_code > 6;
rollback work;
rollback;
