autocommit off;
update joe.shipment_c set product.descr = 'junk';
rollback;
