autocommit off;
delete from all inventory_v (except employees_v);
rollback work;
rollback;
