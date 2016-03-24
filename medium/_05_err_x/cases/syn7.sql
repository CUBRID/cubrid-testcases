autocommit off;

select * 
from dated_inventory_c
where where expiry_date < '1/1/92';
rollback;
