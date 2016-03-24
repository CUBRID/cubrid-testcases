autocommit off;
select *
from dated_inventory_c i
where expiry_date is null
   or expiry_date - '10/10/92' > 30;
rollback;
