autocommit off;
select ssn, name, dept_no, salary, location
  from joe.employees_v e;
insert into joe.employees_v
values (555555555, 'douglas adams', 5, $50000, 'birmingham');
select ssn, name, dept_no, salary, location
  from joe.employees_v e;
rollback work;
rollback;
