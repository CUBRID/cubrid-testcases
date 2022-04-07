autocommit off;
select * 
from joe.dated_inventory_c d
where quantity > 10
  and expiry_date > '9/1/1992';
rollback;
