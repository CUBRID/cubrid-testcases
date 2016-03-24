autocommit off;

update employees_v
   set ssn = (select product_code, descr from inventory_v);
rollback work;
rollback;
