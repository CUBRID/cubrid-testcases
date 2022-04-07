autocommit off;
select *
  from joe.inventory_v i
 where product_code < all { 4, 6 };
rollback;
