autocommit off;
select *
  from all joe.stock_v s
 where product_code between 2 and 5;
rollback;
