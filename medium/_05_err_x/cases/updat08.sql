autocommit off;
update class employees_v
   set ssn = 123123123;
rollback work;
rollback;
