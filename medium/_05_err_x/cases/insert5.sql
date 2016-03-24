autocommit off;
insert into employees_v (ssn, name, dept_no)
values (1000000, select salary from employee_c, 1000);
rollback;
