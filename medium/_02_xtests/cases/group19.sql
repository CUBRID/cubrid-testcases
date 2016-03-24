autocommit off;
  select shipment_pending, sum(quantity)
    from inventory_c i
group by shipment_pending;
rollback;
