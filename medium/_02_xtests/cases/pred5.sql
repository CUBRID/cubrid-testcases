autocommit off;
select * 
from joe.dated_inventory_c d
where expiry_date <= '5/30/92' or expiry_date > '9/1/92';
rollback;
