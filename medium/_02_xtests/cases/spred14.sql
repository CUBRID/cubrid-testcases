autocommit off;
select *
  from deficit_stock_v d
 where deficit_cost >= $20000;
rollback;
