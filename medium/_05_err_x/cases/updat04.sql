autocommit off;
update joe.employees_v
   set ssn = '110000';
rollback work;
rollback;
