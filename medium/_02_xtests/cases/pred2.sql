autocommit off;
select * 
from dated_inventory_c i
where quantity > 10 or
      ( not ( product.product_code < 3 )
        and expiry_date > '9/1/1992' );
rollback;
