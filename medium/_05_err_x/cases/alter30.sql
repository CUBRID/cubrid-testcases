autocommit off;

alter vclass employees_v change query
      select ssn, name, salary, location
        from employee_c;
rollback work;
rollback;
