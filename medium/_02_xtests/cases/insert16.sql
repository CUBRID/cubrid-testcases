autocommit off;
select ssn, name, dept_no, salary, location
  from employees_v e;
insert into employees_v
values (555555555, 'douglas adams', 5, $50000, 'birmingham');
select ssn, name, dept_no, salary, location
  from employees_v e;
rollback work;
rollback;
