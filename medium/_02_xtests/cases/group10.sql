autocommit off;
select price, max(descr) from inventory_v 
group by price
rollback;
