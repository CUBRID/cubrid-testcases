autocommit off;
select product, expiry_date
from dated_inventory_c d
where expiry_date > '1/1/93';
rollback;
