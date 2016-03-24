autocommit off;

alter class employee_c change query
      select ssn, name, dept_no, salary, location
        from employee_c;
rollback work;
rollback;
