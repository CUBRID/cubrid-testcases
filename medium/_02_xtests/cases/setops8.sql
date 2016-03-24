autocommit off;
select product_code
  from unsold_stock_v u
intersection
select product_code
  from surplus_stock_v s;
rollback;
