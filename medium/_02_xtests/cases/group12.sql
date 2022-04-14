autocommit off;
  select location, avg(product.price), max(product.price),
         min(product.price)
    from joe.inventory_c i
group by location;
rollback;
