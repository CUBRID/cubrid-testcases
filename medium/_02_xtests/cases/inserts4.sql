autocommit off;
select *
  from joe.product_c p
 where product_code > 6;
insert into joe.product_c (product_code, descr, price)
values (8, 'rainbow colored magic unicorn thrusters', $1000000);
select *
  from joe.product_c p
 where product_code > 6;
rollback work;
rollback;
