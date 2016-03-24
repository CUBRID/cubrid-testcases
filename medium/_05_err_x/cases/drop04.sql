autocommit off;

drop index idx on employees_v(ssn);
rollback;
