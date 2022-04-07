-- salary not being type-compatible with '1000'.
autocommit off;
insert into joe.employees_v(ssn, name, dept_no, salary)
select ssn, name, dept_no, '1000'
  from joe.employee_c;
rollback work;
rollback;
