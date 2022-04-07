autocommit off;
select price, max(descr) from joe.inventory_v 
group by price;
rollback;
