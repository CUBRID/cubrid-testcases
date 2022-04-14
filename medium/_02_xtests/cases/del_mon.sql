autocommit off;
delete from joe.inventory_v
 where product_code = $1000;
rollback work;
rollback;
