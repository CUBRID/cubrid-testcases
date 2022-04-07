autocommit off;
insert into joe.employees_v (ssn, name, dept_no)
values (1000000, select salary from joe.employee_c, 1000);
rollback;
