autocommit off;
select *
  from joe.deficit_stock_v d
 where deficit_cost >= $20000;
rollback;
