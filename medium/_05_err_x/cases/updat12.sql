autocommit off;
update employees_v
   set ssn = select product_code from inventory_v;
rollback work;
rollback;
