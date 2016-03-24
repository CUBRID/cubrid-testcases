autocommit off;
alter class employee_c drop superclass inventory_c;
rollback work;
rollback;
