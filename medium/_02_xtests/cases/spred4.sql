autocommit off;
select product, expiry_date
from joe.dated_inventory_c d
where expiry_date > '1/1/1993';
rollback;
