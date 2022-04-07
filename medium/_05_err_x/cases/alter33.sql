autocommit off;
alter class joe.employee_c rename column ssn as new_ssn;
select * from joe.employees_v;
rollback work;
rollback;
