autocommit off;
  select shipment_pending, sum(quantity)
    from joe.inventory_c i
group by shipment_pending;
rollback;
