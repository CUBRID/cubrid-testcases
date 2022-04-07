autocommit off;

update joe.employees_v
   set ssn = set {};
rollback work;
rollback;
