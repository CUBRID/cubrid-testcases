autocommit off;
select *
  from surplus_stock_v s
 where surplus_cost <= $5000000;
rollback;
