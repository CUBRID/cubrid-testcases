autocommit off;
update joe.employees_v
   set ssn = avg (dept_no);
rollback work;
rollback;
