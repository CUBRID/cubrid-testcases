autocommit off;
select avg(product.price), avg(quantity)
from joe.dated_inventory_c
where expiry_date is not null;
rollback;
