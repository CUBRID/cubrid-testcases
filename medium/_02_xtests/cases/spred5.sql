autocommit off;
select product.product_code, product.descr, to_location, original_loc
from shipment_c s
where product.product_code in {1, 2, 3};
rollback;
