autocommit off;
update shipment_c set product.descr = 'junk';
rollback;
