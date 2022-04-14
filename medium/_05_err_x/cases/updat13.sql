autocommit off;

update joe.employees_v
   set ssn = (select product_code, descr from joe.inventory_v);
rollback work;
rollback;
