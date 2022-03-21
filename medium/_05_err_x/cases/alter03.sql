autocommit off;
create class joe.employees ( class ssn  int);
create class joe.employees_v under joe.employees;
alter class joe.employee_c drop attribute class ssn;
rollback work;

