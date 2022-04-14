autocommit off;

  select product_code, quantity
    from all joe.inventory_v i
group by product_code, quantity;
rollback;
