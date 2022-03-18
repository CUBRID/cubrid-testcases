autocommit off;
select *
  from joe.shipment_v s
 where origin in {'sussex', 'essex', 'paris'};
rollback;
