autocommit off;
  select product_code, avg(price), max(price), min(price)
    from all inventory_v i
group by product_code;
rollback;
