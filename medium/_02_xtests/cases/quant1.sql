autocommit off;
select product_code, descr, price
from joe.product_c p
where product_code > some (select product.product_code
                             from joe.shipment_c
                            where original_loc = 'paris') order by 1,2;
rollback;
