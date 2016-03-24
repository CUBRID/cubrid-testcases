autocommit off;
update employees_v
   set ssn = '110000';
rollback work;
rollback;
