autocommit off;
select count(distinct product_code)
from joe.inventory_v;
rollback;
