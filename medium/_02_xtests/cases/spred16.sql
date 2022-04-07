autocommit off;
select *
  from all joe.inventory_v i
 where product_code < 4;
rollback;
