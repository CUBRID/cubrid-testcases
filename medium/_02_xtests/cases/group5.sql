autocommit off;
  select origin, avg(quantity) * avg(quantity)
    from shipment_v s
group by origin;
rollback;
