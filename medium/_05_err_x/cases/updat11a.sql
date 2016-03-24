autocommit off;
update employees_v
   set dept_no = avg (dept_no);
rollback;
