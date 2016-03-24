autocommit off;
select ssn, name, dept_no, salary, location
  from employees_v e;
insert into employees_v (ssn, name, dept_no, salary, location)
values (444444444, 'h. de balzac', 4, $25000, 'alsace-lorraine');
select ssn, name, dept_no, salary, location
  from employees_v e;
rollback work;
rollback;
