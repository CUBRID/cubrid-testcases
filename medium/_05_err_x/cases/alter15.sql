autocommit off;

alter class employee_c add superclass object;
rollback work;
rollback;
