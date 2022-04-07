autocommit off;

insert into joe.employees_v(ssn, name, dept_no)
select ssn, 1000, dept_no
  from joe.employee_c;
rollback work;
rollback;
