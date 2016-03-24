autocommit off;

alter vclass employees_v add superclass object;
rollback work;
rollback;
