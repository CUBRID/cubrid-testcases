autocommit off;
select *
  from joe.product_c p
 where product_code = 3;
update joe.product_c
   set descr = 'nietsche is dead',
       price = $100000*5/(25.5+74.5)
 where product_code = 3;
select *
  from joe.product_c p
 where product_code = 3;
rollback work;
rollback;
