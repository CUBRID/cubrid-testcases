autocommit off;

insert into joe.employees_v
select ssn, name, dept_no
  from joe.employee_c;
rollback work;
rollback;
