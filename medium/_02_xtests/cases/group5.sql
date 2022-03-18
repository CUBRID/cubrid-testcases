autocommit off;
  select origin, avg(quantity) * avg(quantity)
    from joe.shipment_v s
group by origin;
rollback;
