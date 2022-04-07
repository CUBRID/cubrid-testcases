autocommit off;
delete from all joe.inventory_v (except joe.employees_v);
rollback work;
rollback;
