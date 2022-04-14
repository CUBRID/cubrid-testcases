autocommit off;
update joe.shipment_c c 
set c.to_location = 'junk',
    c.quantity = 4;
rollback work;
rollback;
