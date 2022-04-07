autocommit off;
select sum(price) / count(price), avg(price)
from joe.inventory_v;
rollback;
