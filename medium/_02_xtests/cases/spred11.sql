autocommit off;
select *
  from inventory_v i
 where product_code > 4;
rollback;
