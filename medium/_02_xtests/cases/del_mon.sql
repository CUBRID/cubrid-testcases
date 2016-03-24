autocommit off;
delete from inventory_v
 where product_code = $1000;
rollback work;
rollback;
