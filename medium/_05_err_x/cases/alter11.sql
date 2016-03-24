autocommit off;

alter vclass employees_v add query select ssn, name, dept_no, salary from employee_c;
rollback work;
rollback;
