autocommit off;
select * 
from joe.dated_inventory_c d
where expiry_date <= '5/30/1992' or expiry_date > '9/1/1992';
rollback;
