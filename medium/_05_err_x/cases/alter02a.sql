autocommit off;
create class joe.employees ( ssn  int);
create class joe.employees_v under joe.employees;
alter class joe.employees_v drop attribute ssn;
rollback;
