autocommit off;
  select shipment_pending, avg(quantity)
    from joe.inventory_c i
group by shipment_pending
order by 1 desc;
rollback;
