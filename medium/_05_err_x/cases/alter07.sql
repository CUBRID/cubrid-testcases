autocommit off;
alter vclass dated_inventory_v drop superclass employees_v;
rollback work;
rollback;
