autocommit off;
select *
  from joe.inventory_v i
 where product_code > 4;
rollback;
