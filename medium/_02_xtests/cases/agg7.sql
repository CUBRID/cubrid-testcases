autocommit off;
select sum(product.price), avg(product.price), min(product.price),
       max(product.price), count(product.price)
from inventory_c
where product.product_code > 2;
rollback;
