autocommit off;
  select shipment_pending, product.product_code, sum(quantity)
    from joe.inventory_c i
group by shipment_pending, product.product_code;
rollback;
