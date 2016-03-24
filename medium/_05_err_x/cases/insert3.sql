autocommit off;

insert into employees_v(ssn, name, dept_no)
select ssn, 1000, dept_no
  from employee_c;
rollback work;
rollback;
