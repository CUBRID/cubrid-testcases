autocommit off;
select avg(product.price)/(max(product.price)-min(product.price))
from inventory_c;
rollback;
