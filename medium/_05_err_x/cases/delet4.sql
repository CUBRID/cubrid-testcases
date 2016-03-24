autocommit off;
delete from inventory_v
 where exists shipment_pending;
rollback work;
rollback;
