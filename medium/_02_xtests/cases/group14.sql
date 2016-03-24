autocommit off;
  select price, avg(quantity), avg(quantity) * price
    from product_c p, shipment_c s
   where s.product.product_code = p.product_code
group by price;
rollback;
