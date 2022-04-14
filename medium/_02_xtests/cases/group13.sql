autocommit off;
  select product.price, avg(quantity), max(quantity), min(quantity)
    from joe.inventory_c i
group by product.price
  having count(*) > 1;
rollback;
