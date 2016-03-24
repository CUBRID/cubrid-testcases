autocommit off;
select *
  from shipment_v s
 where origin in {'sussex', 'essex', 'paris'};
rollback;
