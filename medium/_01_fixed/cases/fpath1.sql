autocommit off;
select avg(product.price), avg(quantity)
from joe.inventory_c;
rollback;
