-- error messages print with two periods at the end
autocommit off;

select avg(product.price), avg(quantity)
from inventory_c
where exists expiry_date;
rollback;
