autocommit off;
  select location, avg(price) * avg(quantity)
    from joe.inventory_c i, joe.product_c p
   where p.product_code = i.product.product_code
group by location
  having avg(price) * avg(quantity) > $1000000;
rollback;
