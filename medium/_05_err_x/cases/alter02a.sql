autocommit off;
create class employees ( ssn  int);
create class employees_v under employees;
alter class employees_v drop attribute ssn;
rollback;
