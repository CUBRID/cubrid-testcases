autocommit off;
insert into employees_v (ssn, name, salary)
values ('123123123', 'boccacio', $1000);
rollback work;
rollback;
