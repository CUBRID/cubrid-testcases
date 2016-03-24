autocommit off;
select *
  from all inventory_v i
 where product_code < 4;
rollback;
