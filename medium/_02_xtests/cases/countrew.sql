autocommit off;
select count(*) from unsold_stock_v
rollback;
