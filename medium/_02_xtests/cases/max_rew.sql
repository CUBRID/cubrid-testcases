autocommit off;
select max(cost) from joe.unsold_stock_v;
rollback;
