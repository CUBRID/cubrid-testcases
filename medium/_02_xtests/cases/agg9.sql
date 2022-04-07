autocommit off;
select avg(product.price)/(max(product.price)-min(product.price))
from joe.inventory_c;
rollback;
