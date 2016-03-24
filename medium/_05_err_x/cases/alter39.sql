autocommit off;

alter class employee_c add superclass employees_v;
rollback work;
rollback;
