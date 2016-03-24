autocommit off;
select distinct count(product_code)
from inventory_v;
rollback;
