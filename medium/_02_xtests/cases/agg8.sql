autocommit off;
select sum(product.price), avg(product.price), min(product.price),
       max(product.price), count(product.price)
from joe.inventory_c;
rollback;
