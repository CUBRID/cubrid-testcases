autocommit off;
select *
  from joe.surplus_stock_v s
 where surplus_cost <= $5000000;
rollback;
