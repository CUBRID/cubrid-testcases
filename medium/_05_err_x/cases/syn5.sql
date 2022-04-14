autocommit off;

select *
from joe.inventory_c
where expiry_date < '01/01/92';
rollback;
