autocommit off;
drop index idx on employee_c(ssn);
rollback;
