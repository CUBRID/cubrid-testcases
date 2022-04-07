autocommit off;
drop index idx on joe.employee_c(ssn);
rollback;
