autocommit off;
select *
  from joe.dated_inventory_v d
 where shipment_pending = 'yes';
rollback;
