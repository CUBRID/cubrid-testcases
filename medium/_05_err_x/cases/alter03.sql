autocommit off;
create class employees ( class ssn  int);
create class employees_v under employees;
alter class employee_c drop attribute class ssn;
rollback work;

