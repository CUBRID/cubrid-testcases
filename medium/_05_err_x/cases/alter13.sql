autocommit off;

alter vclass employees_v add superclass none1;
rollback work;
rollback;
