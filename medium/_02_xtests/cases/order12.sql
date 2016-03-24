autocommit off;
  select product.product_code, product.descr, product.price
    from inventory_c i
order by product.descr asc;
rollback;
