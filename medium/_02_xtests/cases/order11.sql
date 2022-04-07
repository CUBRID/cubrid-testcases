autocommit off;
  select product.product_code, product.descr, product.price
    from joe.inventory_c i
group by product.product_code, product.descr, product.price
order by 3 asc;
rollback;
