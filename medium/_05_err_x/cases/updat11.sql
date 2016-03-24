autocommit off;
update employees_v
   set ssn = avg (dept_no);
rollback work;
rollback;
