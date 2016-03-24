autocommit off;
alter class employees_v drop attribute ssn;
alter class employees_v drop ssn;
rollback work;
rollback;
