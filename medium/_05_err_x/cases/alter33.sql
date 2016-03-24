autocommit off;
alter class employee_c rename column ssn as new_ssn;
select * from employees_v;
rollback work;
rollback;
