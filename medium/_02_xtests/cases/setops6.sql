autocommit off;
select distinct product_code, descr
  from unsold_stock_v u
intersection
select unique product_code, descr
  from deficit_stock_v d;
rollback;
