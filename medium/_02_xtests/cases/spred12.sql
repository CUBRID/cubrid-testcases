autocommit off;
select *
  from dated_inventory_v d
 where shipment_pending = 'yes';
rollback;
