autocommit off;
  select product_code, avg(price)
    from all joe.inventory_v i
group by product_code
order by product_code asc;
rollback;
