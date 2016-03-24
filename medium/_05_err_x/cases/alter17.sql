autocommit off;

rename vclass employee_c as employees_v;
rollback work;
rollback;
