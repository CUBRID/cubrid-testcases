autocommit off;
  select price, avg(quantity), avg(quantity) * price
    from joe.product_c p, joe.shipment_c s
   where s.product.product_code = p.product_code
group by price;
rollback;
