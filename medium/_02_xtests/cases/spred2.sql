autocommit off;
select product, quantity, shipment_pending
from joe.inventory_c i
where shipment_pending = 'yes';
rollback;
