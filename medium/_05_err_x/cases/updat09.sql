autocommit off;
update employee
   set ssn = inventory_v.product_code;
rollback work;
rollback;
