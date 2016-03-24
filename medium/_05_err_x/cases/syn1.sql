autocommit off;

select all unique product_code, qunatity
from inventory_v;
rollback;
