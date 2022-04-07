autocommit off;

rename vclass joe.employee_c as joe.employees_v;
rollback work;
rollback;
