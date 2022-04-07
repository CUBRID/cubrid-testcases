autocommit off;
select product_code, descr
  from joe.unsold_stock_v u
intersection
select product_code, descr
  from joe.deficit_stock_v d;
rollback;
