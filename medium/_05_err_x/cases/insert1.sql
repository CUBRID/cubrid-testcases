autocommit off;

insert into employees_v
select ssn, name, dept_no
  from employee_c;
rollback work;
rollback;
