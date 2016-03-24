autocommit off;
select sum(price) / count(price), avg(price)
from inventory_v;
rollback;
