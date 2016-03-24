autocommit off;
  select shipment_pending, product.product_code, product.descr, product.price
    from inventory_c i
group by product.product_code, shipment_pending, product.descr, product.price
order by 1 asc;
rollback;
