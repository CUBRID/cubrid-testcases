autocommit off;
select max(cost) from unsold_stock_v
rollback;
