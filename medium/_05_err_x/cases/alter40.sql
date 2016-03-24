autocommit off;

alter vclass employees_v add superclass employee_c;
rollback work;
rollback;
