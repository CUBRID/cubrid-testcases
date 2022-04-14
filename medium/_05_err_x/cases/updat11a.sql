autocommit off;
update joe.employees_v
   set dept_no = avg (dept_no);
rollback;
