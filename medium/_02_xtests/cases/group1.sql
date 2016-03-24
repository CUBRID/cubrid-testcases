autocommit off;

  select product_code, quantity
    from all inventory_v i
group by product_code, quantity;
rollback;
