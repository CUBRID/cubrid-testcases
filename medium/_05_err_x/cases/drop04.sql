autocommit off;

drop index idx on joe.employees_v(ssn);
rollback;
