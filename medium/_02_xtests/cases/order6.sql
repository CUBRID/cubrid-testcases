autocommit off;
  select product_code, descr, price
    from all joe.inventory_v i
order by descr asc;
rollback;
