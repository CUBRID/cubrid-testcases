autocommit off;
select distinct count(product_code)
from joe.inventory_v;
rollback;
