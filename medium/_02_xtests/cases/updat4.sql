autocommit off;
select *
  from joe.product_c p
 where product_code > 6;
update joe.product_c
   set descr = 'rainbow colored magic unicorn thrusters',
       price = $1000000*3/4
 where product_code = 7;
select *
  from joe.product_c p
 where product_code > 6;
rollback work;
rollback;
