-- salary not being type-compatible with '1000'.
autocommit off;
insert into employees_v(ssn, name, dept_no, salary)
select ssn, name, dept_no, '1000'
  from employee_c;
rollback work;
rollback;
