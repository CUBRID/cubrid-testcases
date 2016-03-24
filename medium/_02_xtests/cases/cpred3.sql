autocommit off;
select * 
from dated_inventory_c d
where quantity > 10
  and expiry_date > '9/1/92';
rollback;
