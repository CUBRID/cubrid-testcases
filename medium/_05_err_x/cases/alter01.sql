autocommit off;
alter vclass employee_c drop attribute class ssn;
rollback work;
rollback;
