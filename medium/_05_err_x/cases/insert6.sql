autocommit off;
insert into rdb.employees_v (ssn, name, dept_no, salary, location)
values (555555555, 'douglas adams', 5, $50000, 'birmingham');
rollback;
