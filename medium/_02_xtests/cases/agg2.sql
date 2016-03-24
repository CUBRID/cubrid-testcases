autocommit off;
select count(distinct product_code)
from inventory_v;
rollback;
