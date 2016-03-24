autocommit off;
select avg(product.price), avg(quantity)
from inventory_c;
rollback;
