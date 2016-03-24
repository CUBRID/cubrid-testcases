autocommit off;
select count(product_code)
from inventory_v;
rollback;
