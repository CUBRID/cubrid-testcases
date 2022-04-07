autocommit off;
  select price, avg(quantity), price * avg(quantity)
    from joe.inventory_c i, joe.product_c p
   where p.product_code = i.product.product_code
group by price
  having price * avg(quantity) > $1000000;
rollback;
