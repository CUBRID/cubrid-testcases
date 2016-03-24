autocommit off;
create class employees ( ssn  int);
create class employees_c under employees;
alter class employee_c drop query;
rollback work;
rollback;
