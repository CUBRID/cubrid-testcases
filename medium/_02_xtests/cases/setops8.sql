autocommit off;
select product_code
  from joe.unsold_stock_v u
intersection
select product_code
  from joe.surplus_stock_v s;
rollback;
