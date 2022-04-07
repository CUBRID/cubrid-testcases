autocommit off;
select distinct product_code
  from joe.unsold_stock_v u
intersection
select distinct product_code
  from joe.surplus_stock_v s;
rollback;
