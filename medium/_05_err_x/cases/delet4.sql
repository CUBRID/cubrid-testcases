autocommit off;
delete from joe.inventory_v
 where exists shipment_pending;
rollback work;
rollback;
