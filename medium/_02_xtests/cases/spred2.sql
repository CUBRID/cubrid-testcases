autocommit off;
select product, quantity, shipment_pending
from inventory_c i
where shipment_pending = 'yes';
rollback;
