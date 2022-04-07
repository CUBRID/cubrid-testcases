autocommit off;
select count(product_code)
from joe.inventory_v;
rollback;
